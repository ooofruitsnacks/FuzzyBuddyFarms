package main

import "core:net"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

NET_PROTOCOL_VERSION :: u32(1)
NET_MAX_PLAYERS       :: 8
NET_PORT_DEFAULT      :: 7777
NET_PACKET_BUF_SIZE   :: 512
NET_SEND_RATE         :: f32(0.05)
NET_TIMEOUT_SECONDS   :: f32(5.0)

NET_PASSPHRASE_LEN       :: 16
NET_MAX_UNAUTH_TRACK     :: 16
NET_JOIN_MIN_INTERVAL    :: f32(1)
NET_MAX_PACKETS_PER_SEC  :: 40

NET_ADDRESS_LEN     :: 24
NET_CHUNK_DATA_SIZE :: 400
NET_ACTION_MSG_LEN  :: 64

Net_Role :: enum { None, Host, Client }

Packet_Type :: enum u8 {
    Join, Welcome, PlayerState, Leave, StartGame,
    PlotAction,
    WorldSyncStart,
    WorldSyncChunk,
    WorldSyncEnd,
    ActionResult,
}

packet_kind_is_valid :: proc(k: Packet_Type) -> bool {
    switch k {
    case .Join, .Welcome, .PlayerState, .Leave, .StartGame,
         .PlotAction, .WorldSyncStart, .WorldSyncChunk, .WorldSyncEnd, .ActionResult:
        return true
    }
    return false
}

PlotActionType :: enum u8 { PlantTree, PlantFlower, DeployQueen, BuyPlot, PlaceBox, CollectHoney, BuyBuilding }

plot_action_is_valid :: proc(a: PlotActionType) -> bool {
    switch a {
    case .PlantTree, .PlantFlower, .DeployQueen, .BuyPlot, .PlaceBox, .CollectHoney, .BuyBuilding:
        return true
    }
    return false
}

box_kind_is_valid :: proc(k: BoxType) -> bool {
    return int(k) >= 0 && int(k) < len(BoxType)
}

Net_Player_Snapshot :: struct {
    id:               u32,
    pos:              [2]f32,
    shirt_color:      rl.Color,
    pants_color:      rl.Color,
    hat_color:        rl.Color,
    skin_color:       rl.Color,
    clothing_pattern: ClothingPattern,
    pattern_color:    rl.Color,
    in_car:           bool,
    car_kind:         CarType,
    car_angle:        f32,
    animal_kind:      AnimalBuddyType,
    animal_visible:   bool,
    animal_pos:       [2]f32,
}

Packet :: struct {
    kind:           Packet_Type,
    proto_ver:      u32,
    session_token:  u64,
    player:         Net_Player_Snapshot,
    passphrase:     [NET_PASSPHRASE_LEN]u8,
    passphrase_len: int,
}

Net_Plot :: struct {
    rect:            [4]f32,
    size:            PlotSize,
    cost:            f32,
    owned:           bool,
    owner_is_player: bool,
    tree_count:      int,
    flower_count:    int,
    address:         [NET_ADDRESS_LEN]u8,
    address_len:     int,
}

Net_BeeBox :: struct {
    pos:        [2]f32,
    kind:       BoxType,
    honey_ml:   f32,
    capacity:   f32,
    bee_count:  int,
    active:     bool,
    on_plot:    int,
    queen_tier: int,
}

Net_Building :: struct {
    kind:  BuildingType,
    owned: bool,
}

World_Snapshot_Header :: struct {
    day_time:       f32,
    is_night:       bool,
    season_time:    f32,
    season:         Season,
    plot_count:     int,
    beebox_count:   int,
    building_count: int,
}

WorldSync_Start_Packet :: struct {
    kind:        Packet_Type,
    proto_ver:   u32,
    total_bytes: int,
    header:      World_Snapshot_Header,
}

WorldSync_Chunk_Packet :: struct {
    kind:        Packet_Type,
    proto_ver:   u32,
    chunk_index: int,
    chunk_len:   int,
    data:        [NET_CHUNK_DATA_SIZE]u8,
}

WorldSync_End_Packet :: struct {
    kind:      Packet_Type,
    proto_ver: u32,
}

World_Sync_Buffer :: struct {
    in_progress: bool,
    header:      World_Snapshot_Header,
    total_bytes: int,
    data:        [dynamic]u8,
}

world_sync_buf: World_Sync_Buffer

PlotAction_Packet :: struct {
    kind:         Packet_Type,
    proto_ver:    u32,
    requester_id: u32,
    plot_index:   int,
    action:       PlotActionType,
    pos:          [2]f32,
    box_kind:     BoxType,
}

ActionResult_Packet :: struct {
    kind:      Packet_Type,
    proto_ver: u32,
    success:   bool,
    msg_len:   int,
    msg:       [NET_ACTION_MSG_LEN]u8,
}

#assert(NET_PACKET_BUF_SIZE >= size_of(Packet))
#assert(NET_PACKET_BUF_SIZE >= size_of(WorldSync_Start_Packet))
#assert(NET_PACKET_BUF_SIZE >= size_of(WorldSync_Chunk_Packet))
#assert(NET_PACKET_BUF_SIZE >= size_of(WorldSync_End_Packet))
#assert(NET_PACKET_BUF_SIZE >= size_of(PlotAction_Packet))
#assert(NET_PACKET_BUF_SIZE >= size_of(ActionResult_Packet))

Remote_Player :: struct {
    id:        u32,
    active:    bool,
    snapshot:  Net_Player_Snapshot,
    last_seen: f32,
}

Unauth_Entry :: struct {
    ep:                net.Endpoint,
    used:              bool,
    last_join_attempt: f32,
}

Net_State :: struct {
    role:              Net_Role,
    socket:            net.UDP_Socket,
    host_ep:           net.Endpoint,
    client_eps:        [NET_MAX_PLAYERS]net.Endpoint,
    client_active:     [NET_MAX_PLAYERS]bool,
    local_id:          u32,
    next_id:           u32,
    remotes:           [NET_MAX_PLAYERS]Remote_Player,
    send_timer:        f32,

    passphrase:        [NET_PASSPHRASE_LEN]u8,
    passphrase_len:    int,
    unauth_tracker:    [NET_MAX_UNAUTH_TRACK]Unauth_Entry,
    rate_window_start: [NET_MAX_PLAYERS]f32,
    rate_count:        [NET_MAX_PLAYERS]int,
}

net_state: Net_State

set_passphrase :: proc(dst: ^[NET_PASSPHRASE_LEN]u8, src: string) -> int {
    n := min(len(src), NET_PASSPHRASE_LEN)
    for i in 0..<NET_PASSPHRASE_LEN { dst[i] = 0 }
    copy(dst[:n], src[:n])
    return n
}

passphrases_match :: proc(a: [NET_PASSPHRASE_LEN]u8, a_len: int, b: [NET_PASSPHRASE_LEN]u8, b_len: int) -> bool {
    diff := u8(a_len ~ b_len)
    for i in 0..<NET_PASSPHRASE_LEN {
        diff |= a[i] ~ b[i]
    }
    return diff == 0
}

find_or_add_unauth_slot :: proc(ep: net.Endpoint) -> int {
    now := f32(rl.GetTime())
    oldest_idx := 0
    oldest_time := f32(1e18)

    for i in 0..<NET_MAX_UNAUTH_TRACK {
        e := &net_state.unauth_tracker[i]
        if e.used && e.ep == ep { return i }
        if !e.used { return i }
        if e.last_join_attempt < oldest_time {
            oldest_time = e.last_join_attempt
            oldest_idx  = i
        }
    }

    if now - oldest_time > NET_JOIN_MIN_INTERVAL {
        return oldest_idx
    }
    return -1
}

join_attempt_allowed :: proc(ep: net.Endpoint) -> bool {
    idx := find_or_add_unauth_slot(ep)
    if idx < 0 { return false }

    now := f32(rl.GetTime())
    e := &net_state.unauth_tracker[idx]
    if e.used && e.ep == ep && now - e.last_join_attempt < NET_JOIN_MIN_INTERVAL {
        return false
    }
    e.used              = true
    e.ep                = ep
    e.last_join_attempt = now
    return true
}

player_rate_limited :: proc(slot: int) -> bool {
    now := f32(rl.GetTime())
    if now - net_state.rate_window_start[slot] >= 1.0 {
        net_state.rate_window_start[slot] = now
        net_state.rate_count[slot]        = 0
    }
    net_state.rate_count[slot] += 1
    return net_state.rate_count[slot] > NET_MAX_PACKETS_PER_SEC
}

net_host_start :: proc(port: int = NET_PORT_DEFAULT, passphrase: string = "") -> bool {
    addr := net.parse_address("0.0.0.0")
    if addr == nil { return false }
    sock, err := net.make_bound_udp_socket(addr, port)
    if err != nil {
        show_message("Failed to start host — port may be in use.", 4)
        return false
    }
    net.set_blocking(sock, false)

    net_state = Net_State{}
    net_state.role     = .Host
    net_state.socket    = sock
    net_state.local_id  = 0
    net_state.next_id   = 1
    net_state.passphrase_len = set_passphrase(&net_state.passphrase, passphrase)

    if net_state.passphrase_len > 0 {
        show_message("Multiplayer host started (passphrase protected).", 4)
    } else {
        show_message("Multiplayer host started! Friends can now join on your LAN.", 4)
    }
    return true
}

net_client_connect :: proc(host_ip: string, port: int = NET_PORT_DEFAULT, passphrase: string = "") -> bool {
    sock, err := net.make_unbound_udp_socket(.IP4)
    if err != nil {
        show_message("Failed to open network socket.", 4)
        return false
    }
    net.set_blocking(sock, false)

    addr := net.parse_address(host_ip)
    if addr == nil {
        show_message("Invalid host IP address.", 4)
        return false
    }

    net_state = Net_State{}
    net_state.role    = .Client
    net_state.socket   = sock
    net_state.host_ep  = net.Endpoint{address = addr, port = port}

    join_pkt := Packet{kind = .Join, proto_ver = NET_PROTOCOL_VERSION}
    join_pkt.passphrase_len = set_passphrase(&join_pkt.passphrase, passphrase)
    buf := transmute([size_of(Packet)]u8)join_pkt
    net.send_udp(sock, buf[:], net_state.host_ep)

    show_message("Connecting to host...", 3)
    return true
}

net_shutdown :: proc() {
    if net_state.role == .None { return }
    leave_pkt := Packet{kind = .Leave, proto_ver = NET_PROTOCOL_VERSION,
        player = Net_Player_Snapshot{id = net_state.local_id}}
    net_broadcast(leave_pkt)
    net.close(net_state.socket)
    delete(world_sync_buf.data)
    world_sync_buf = World_Sync_Buffer{}
    net_state = Net_State{}
}

net_update :: proc() {
    if net_state.role == .None { return }

    buf: [NET_PACKET_BUF_SIZE]u8
    for {
        n, from, err := net.recv_udp(net_state.socket, buf[:])
        if err != nil || n <= 0 { break }
        if n < 1 { continue }

        kind := Packet_Type(buf[0])
        if !packet_kind_is_valid(kind) { continue }

        switch kind {
        case .WorldSyncStart:
            if n != size_of(WorldSync_Start_Packet) { continue }
            p := (^WorldSync_Start_Packet)(raw_data(buf[:]))^
            if p.proto_ver == NET_PROTOCOL_VERSION { net_on_world_sync_start(p) }

        case .WorldSyncChunk:
            if n != size_of(WorldSync_Chunk_Packet) { continue }
            p := (^WorldSync_Chunk_Packet)(raw_data(buf[:]))^
            if p.proto_ver == NET_PROTOCOL_VERSION { net_on_world_sync_chunk(p) }

        case .WorldSyncEnd:
            if n != size_of(WorldSync_End_Packet) { continue }
            p := (^WorldSync_End_Packet)(raw_data(buf[:]))^
            if p.proto_ver == NET_PROTOCOL_VERSION { net_on_world_sync_end() }

        case .PlotAction:
            if n != size_of(PlotAction_Packet) { continue }
            p := (^PlotAction_Packet)(raw_data(buf[:]))^
            if p.proto_ver == NET_PROTOCOL_VERSION { net_on_plot_action(p, from) }

        case .ActionResult:
            if n != size_of(ActionResult_Packet) { continue }
            p := (^ActionResult_Packet)(raw_data(buf[:]))^
            if p.proto_ver == NET_PROTOCOL_VERSION { net_on_action_result(p) }

        case .Join, .Welcome, .PlayerState, .Leave, .StartGame:
            if n != size_of(Packet) { continue }
            pkt := (^Packet)(raw_data(buf[:]))^
            if pkt.proto_ver == NET_PROTOCOL_VERSION { net_handle_packet(pkt, from) }
        }
    }

    net_state.send_timer += g.dt
    if net_state.send_timer >= NET_SEND_RATE {
        net_state.send_timer = 0
        net_send_my_state()
    }

    now := f32(rl.GetTime())
    for i in 0..<NET_MAX_PLAYERS {
        r := &net_state.remotes[i]
        if r.active && now - r.last_seen > NET_TIMEOUT_SECONDS {
            r.active = false
        }
    }
}

net_handle_packet :: proc(pkt: Packet, from: net.Endpoint) {
    for i in 0..<NET_MAX_PLAYERS {
        if net_state.client_active[i] && net_state.client_eps[i] == from {
            if player_rate_limited(i) { return }
            break
        }
    }

    switch pkt.kind {
    case .StartGame:
        if net_state.role == .Client {
            g.state = .World
            show_message("The host started the game!", 3)
        }

    case .Join:
        if net_state.role != .Host { return }
        if !join_attempt_allowed(from) { return }

        if net_state.passphrase_len > 0 {
            if !passphrases_match(pkt.passphrase, pkt.passphrase_len,
                                   net_state.passphrase, net_state.passphrase_len) {
                return
            }
        }

        for i in 0..<NET_MAX_PLAYERS {
            if !net_state.client_active[i] {
                net_state.client_active[i]     = true
                net_state.client_eps[i]        = from
                net_state.rate_window_start[i] = f32(rl.GetTime())
                net_state.rate_count[i]        = 0
                assigned_id := net_state.next_id
                net_state.next_id += 1

                welcome := Packet{kind = .Welcome, proto_ver = NET_PROTOCOL_VERSION,
                    player = Net_Player_Snapshot{id = assigned_id}}
                wbuf := transmute([size_of(Packet)]u8)welcome
                net.send_udp(net_state.socket, wbuf[:], from)

                net_send_world_snapshot(from)

                show_message("A farmer has joined Honeyville!", 4)
                return
            }
        }

    case .Welcome:
        if net_state.role != .Client { return }
        net_state.local_id = pkt.player.id

    case .PlayerState:
        net_store_remote(pkt.player)
        if net_state.role == .Host {
            for i in 0..<NET_MAX_PLAYERS {
                if net_state.client_active[i] && net_state.client_eps[i] != from {
                    rbuf := transmute([size_of(Packet)]u8)pkt
                    net.send_udp(net_state.socket, rbuf[:], net_state.client_eps[i])
                }
            }
        }

    case .Leave:
        for i in 0..<NET_MAX_PLAYERS {
            if net_state.remotes[i].id == pkt.player.id {
                net_state.remotes[i].active = false
            }
        }
        if net_state.role == .Host {
            for i in 0..<NET_MAX_PLAYERS {
                if net_state.client_eps[i] == from {
                    net_state.client_active[i] = false
                }
            }
        }

    case .PlotAction, .WorldSyncStart, .WorldSyncChunk, .WorldSyncEnd, .ActionResult:
    }
}

net_start_game :: proc() {
    pkt := Packet{kind = .StartGame, proto_ver = NET_PROTOCOL_VERSION}
    net_broadcast(pkt)
    g.state = .World
}
clothing_pattern_is_valid :: proc(p: ClothingPattern) -> bool {
    return int(p) >= 0 && int(p) < len(ClothingPattern)
}
car_kind_is_valid :: proc(p: CarType) -> bool {
    return int(p) >= 0 && int(p) < len(CarType)
}
animal_buddy_kind_is_valid :: proc(p: AnimalBuddyType) -> bool {
    return int(p) >= 0 && int(p) < len(AnimalBuddyType)
}

net_store_remote :: proc(snap: Net_Player_Snapshot) {
    if snap.id == net_state.local_id { return }

    for i in 0..<NET_MAX_PLAYERS {
        r := &net_state.remotes[i]
        if r.active && r.id == snap.id {
            r.snapshot  = snap
            r.last_seen = f32(rl.GetTime())
            return
        }
    }
    for i in 0..<NET_MAX_PLAYERS {
        r := &net_state.remotes[i]
        if !r.active {
            r.active    = true
            r.id        = snap.id
            r.snapshot  = snap
            r.last_seen = f32(rl.GetTime())
            return
        }
    }
}

net_send_my_state :: proc() {
    snap := Net_Player_Snapshot{
        id               = net_state.local_id,
        pos              = {g.player.pos.x, g.player.pos.y},
        shirt_color      = g.player.shirt_color,
        pants_color      = g.player.pants_color,
        hat_color        = g.player.hat_color,
        skin_color       = g.player.skin_color,
        clothing_pattern = g.player.clothing_pattern,
        pattern_color    = g.player.pattern_color,
        in_car           = g.in_car,
        animal_visible   = g.animal_buddy.visible,
        animal_kind      = g.animal_buddy.kind,
        animal_pos       = {g.animal_buddy.pos.x, g.animal_buddy.pos.y},
    }
    if g.in_car && g.current_car >= 0 && g.current_car < MAX_CARS {
        snap.car_kind  = g.cars[g.current_car].kind
        snap.car_angle = g.cars[g.current_car].angle
    }

    pkt := Packet{kind = .PlayerState, proto_ver = NET_PROTOCOL_VERSION, player = snap}
    net_broadcast(pkt)
}

net_broadcast :: proc(pkt: Packet) {
    buf := transmute([size_of(Packet)]u8)pkt
    if net_state.role == .Client {
        net.send_udp(net_state.socket, buf[:], net_state.host_ep)
    } else if net_state.role == .Host {
        for i in 0..<NET_MAX_PLAYERS {
            if net_state.client_active[i] {
                net.send_udp(net_state.socket, buf[:], net_state.client_eps[i])
            }
        }
    }
}


net_send_world_snapshot :: proc(to: net.Endpoint) {
    plot_count     := len(g.plots)
    beebox_count   := len(g.bee_boxes)
    building_count := len(g.buildings)

    total := plot_count*size_of(Net_Plot) + beebox_count*size_of(Net_BeeBox) + building_count*size_of(Net_Building)
    buf := make([dynamic]u8, 0, total)
    defer delete(buf)

    for p in g.plots {
        np := Net_Plot{
            rect = {p.rect.x, p.rect.y, p.rect.width, p.rect.height},
            size = p.size, cost = p.cost, owned = p.owned, owner_is_player = p.owner_is_player,
            tree_count = len(p.trees), flower_count = len(p.flowers),
        }
        alen := min(len(p.address), NET_ADDRESS_LEN)
        np.address_len = alen
        copy(np.address[:alen], transmute([]u8)p.address[:alen])
        b := transmute([size_of(Net_Plot)]u8)np
        append(&buf, ..b[:])
    }
    for bb in g.bee_boxes {
        nb := Net_BeeBox{
            pos = {bb.pos.x, bb.pos.y}, kind = bb.kind, honey_ml = bb.honey_ml,
            capacity = bb.capacity, bee_count = bb.bee_count, active = bb.active,
            on_plot = bb.on_plot, queen_tier = bb.queen_tier,
        }
        b := transmute([size_of(Net_BeeBox)]u8)nb
        append(&buf, ..b[:])
    }
    for bld, kind in g.buildings {
        nbld := Net_Building{kind = kind, owned = bld.owned}
        b := transmute([size_of(Net_Building)]u8)nbld
        append(&buf, ..b[:])
    }

    header := World_Snapshot_Header{
        day_time = g.day_time, is_night = g.is_night, season_time = g.season_time, season = g.season,
        plot_count = plot_count, beebox_count = beebox_count, building_count = building_count,
    }
    start := WorldSync_Start_Packet{kind = .WorldSyncStart, proto_ver = NET_PROTOCOL_VERSION,
        total_bytes = len(buf), header = header}
    sbuf := transmute([size_of(WorldSync_Start_Packet)]u8)start
    net.send_udp(net_state.socket, sbuf[:], to)

    offset, idx := 0, 0
    for offset < len(buf) {
        n := min(NET_CHUNK_DATA_SIZE, len(buf)-offset)
        chunk := WorldSync_Chunk_Packet{kind = .WorldSyncChunk, proto_ver = NET_PROTOCOL_VERSION,
            chunk_index = idx, chunk_len = n}
        copy(chunk.data[:n], buf[offset:offset+n])
        cbuf := transmute([size_of(WorldSync_Chunk_Packet)]u8)chunk
        net.send_udp(net_state.socket, cbuf[:], to)
        offset += n; idx += 1
    }

    end := WorldSync_End_Packet{kind = .WorldSyncEnd, proto_ver = NET_PROTOCOL_VERSION}
    ebuf := transmute([size_of(WorldSync_End_Packet)]u8)end
    net.send_udp(net_state.socket, ebuf[:], to)
}

net_broadcast_world_snapshot :: proc() {
    if net_state.role != .Host { return }
    for i in 0..<NET_MAX_PLAYERS {
        if net_state.client_active[i] { net_send_world_snapshot(net_state.client_eps[i]) }
    }
}

net_on_world_sync_start :: proc(p: WorldSync_Start_Packet) {
    if p.total_bytes < 0 || p.total_bytes > 2_000_000 { return }
    delete(world_sync_buf.data)
    world_sync_buf = World_Sync_Buffer{in_progress = true, header = p.header,
        total_bytes = p.total_bytes, data = make([dynamic]u8, p.total_bytes)}

    if p.header.plot_count < 0 || p.header.plot_count > 10_000 { world_sync_buf.in_progress = false; return }
    if p.header.beebox_count < 0 || p.header.beebox_count > 10_000 { world_sync_buf.in_progress = false; return }
    resize(&g.plots, p.header.plot_count)
    resize(&g.bee_boxes, p.header.beebox_count)
}

net_on_world_sync_chunk :: proc(p: WorldSync_Chunk_Packet) {
    if !world_sync_buf.in_progress { return }
    if p.chunk_len < 0 || p.chunk_len > NET_CHUNK_DATA_SIZE { return }
    start := p.chunk_index * NET_CHUNK_DATA_SIZE
    end   := start + p.chunk_len
    if start < 0 || end > len(world_sync_buf.data) { return }
    p := p
    copy(world_sync_buf.data[start:end], p.data[:p.chunk_len])
}

net_on_world_sync_end :: proc() {
    if !world_sync_buf.in_progress { return }
    defer { world_sync_buf.in_progress = false }
    h := world_sync_buf.header
    off := 0

    for i in 0..<h.plot_count {
        if off + size_of(Net_Plot) > len(world_sync_buf.data) { return }
        raw: [size_of(Net_Plot)]u8
        copy(raw[:], world_sync_buf.data[off:off+size_of(Net_Plot)])
        np := transmute(Net_Plot)raw
        off += size_of(Net_Plot)

        g.plots[i].rect            = rl.Rectangle{np.rect[0], np.rect[1], np.rect[2], np.rect[3]}
        g.plots[i].size            = np.size
        g.plots[i].cost            = np.cost
        g.plots[i].owned           = np.owned
        g.plots[i].owner_is_player = np.owner_is_player
        delete(g.plots[i].address)
        g.plots[i].address         = strings.clone(string(np.address[:np.address_len]))

        clear(&g.plots[i].trees)
        for t in 0..<np.tree_count {
            append(&g.plots[i].trees, Vec2{np.rect[0]+f32(t%4)*20+10, np.rect[1]+f32(t/4)*20+10})
        }
        clear(&g.plots[i].flowers)
        for f in 0..<np.flower_count {
            append(&g.plots[i].flowers, Vec2{np.rect[0]+f32(f%5)*16+8, np.rect[1]+f32(f/5)*16+8})
        }
    }

    for i in 0..<h.beebox_count {
        if off + size_of(Net_BeeBox) > len(world_sync_buf.data) { return }
        raw: [size_of(Net_BeeBox)]u8
        copy(raw[:], world_sync_buf.data[off:off+size_of(Net_BeeBox)])
        nb := transmute(Net_BeeBox)raw
        off += size_of(Net_BeeBox)

        g.bee_boxes[i].pos = Vec2{nb.pos[0], nb.pos[1]}
        g.bee_boxes[i].kind = nb.kind; g.bee_boxes[i].honey_ml = nb.honey_ml
        g.bee_boxes[i].capacity = nb.capacity; g.bee_boxes[i].bee_count = nb.bee_count
        g.bee_boxes[i].active = nb.active; g.bee_boxes[i].on_plot = nb.on_plot
        g.bee_boxes[i].queen_tier = nb.queen_tier
    }

    for i in 0..<h.building_count {
        if off + size_of(Net_Building) > len(world_sync_buf.data) { return }
        raw: [size_of(Net_Building)]u8
        copy(raw[:], world_sync_buf.data[off:off+size_of(Net_Building)])
        nbld := transmute(Net_Building)raw
        off += size_of(Net_Building)
        g.buildings[nbld.kind].owned = nbld.owned
    }

    for i in 0..<len(g.plots) { clear(&g.plots[i].boxes) }
    for i in 0..<len(g.bee_boxes) {
        op := g.bee_boxes[i].on_plot
        if op >= 0 && op < len(g.plots) {
            append(&g.plots[op].boxes, i)
        }
    }

    g.day_time = h.day_time; g.is_night = h.is_night
    g.season_time = h.season_time; g.season = h.season
    show_message("World synced!", 2)
}

net_request_plot_action :: proc(plot_index: int, action: PlotActionType, pos: Vec2, box_kind: BoxType = .SmallGround) {
    if net_state.role != .Client { return }
    pkt := PlotAction_Packet{kind = .PlotAction, proto_ver = NET_PROTOCOL_VERSION,
        requester_id = net_state.local_id, plot_index = plot_index, action = action,
        pos = {pos.x, pos.y}, box_kind = box_kind}
    buf := transmute([size_of(PlotAction_Packet)]u8)pkt
    net.send_udp(net_state.socket, buf[:], net_state.host_ep)
}

net_on_plot_action :: proc(pkt: PlotAction_Packet, from: net.Endpoint) {
    if net_state.role != .Host { return }
    if !plot_action_is_valid(pkt.action) { return }
    if !box_kind_is_valid(pkt.box_kind) { return }

    requester_slot := -1
    for i in 0..<NET_MAX_PLAYERS {
        if net_state.client_active[i] && net_state.client_eps[i] == from { requester_slot = i; break }
    }
    if requester_slot < 0 { return }
    if player_rate_limited(requester_slot) { return }

    pos := Vec2{pkt.pos[0], pkt.pos[1]}
    ok := false
    msg := ""
    switch pkt.action {
    case .PlantFlower:  ok, msg = apply_plant_flower(pkt.plot_index, pos)
    case .PlantTree:    ok, msg = apply_plant_tree(pkt.plot_index, pos)
    case .DeployQueen:  ok, msg = apply_deploy_queen(pos)
    case .BuyPlot:      ok, msg = apply_buy_plot(pkt.plot_index)
    case .CollectHoney: ok, msg = apply_collect_honey(pos)
    case .PlaceBox:     ok, msg = apply_place_box(pkt.plot_index, pkt.box_kind)
    case .BuyBuilding:
        bt: BuildingType
        valid := false
        for cand in BuildingType {
            if int(cand) == pkt.plot_index { bt = cand; valid = true; break }
        }
        if valid { ok, msg = apply_buy_building(bt) } else { ok, msg = false, "Invalid building." }
    }

    net_send_action_result(from, ok, msg)
    if ok { net_broadcast_world_snapshot() }
}

net_send_action_result :: proc(to: net.Endpoint, success: bool, msg: string) {
    n := min(len(msg), NET_ACTION_MSG_LEN)
    pkt := ActionResult_Packet{kind = .ActionResult, proto_ver = NET_PROTOCOL_VERSION,
        success = success, msg_len = n}
    copy(pkt.msg[:n], msg[:n])
    buf := transmute([size_of(ActionResult_Packet)]u8)pkt
    net.send_udp(net_state.socket, buf[:], to)
}

net_on_action_result :: proc(p: ActionResult_Packet) {
    if net_state.role != .Client { return }
    if p.msg_len < 0 || p.msg_len > NET_ACTION_MSG_LEN { return }
    if p.msg_len == 0 { return }
    p := p
    show_message(string(p.msg[:p.msg_len]))
}

draw_remote_players :: proc() {
    if net_state.role == .None { return }

    for i in 0..<NET_MAX_PLAYERS {
        r := &net_state.remotes[i]
        if !r.active { continue }
        s := r.snapshot

        x := pxi(s.pos[0]); y := pxi(s.pos[1])
        rl.DrawEllipse(x, y+10, 8, 3, COL_SHADOW)
        rl.DrawRectangle(x-6, y+14, 5, 5, {48,32,16,255})
        rl.DrawRectangle(x+1, y+14, 5, 5, {48,32,16,255})
        rl.DrawRectangle(x-5, y+6, 4, 10, s.pants_color)
        rl.DrawRectangle(x+1, y+6, 4, 10, s.pants_color)
        rl.DrawRectangle(x-7, y-2, 14, 10, s.shirt_color)
        rl.DrawRectangle(x-11, y-1, 5, 8, s.shirt_color)
        rl.DrawRectangle(x+6,  y-1, 5, 8, s.shirt_color)
        rl.DrawRectangle(x-2, y-6, 4, 5, s.skin_color)
        rl.DrawRectangle(x-5, y-14, 10, 10, s.skin_color)
        rl.DrawRectangle(x-3, y-11, 2, 2, {40,30,20,255})
        rl.DrawRectangle(x+1, y-11, 2, 2, {40,30,20,255})
        rl.DrawRectangle(x-7, y-16, 14, 4, s.hat_color)
        rl.DrawRectangle(x-5, y-22, 10, 8, s.hat_color)

        name := fmt.aprintf("Player %d", s.id, allocator = context.temp_allocator)
        cstr := strings.clone_to_cstring(name, context.temp_allocator)
        tw   := rl.MeasureText(cstr, 7)
        rl.DrawText(cstr, x - tw/2, y-30, 7, COL_HONEY2)
    }
}

net_on_quit :: proc() {
    net_shutdown()
}

