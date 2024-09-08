"""
    create_skippable_frame(user_data::AbstractVector{UInt8}, magic_number::UInt32=0x184D2A50)::Vector{UInt8}

Return a skippable frame containing `user_data`.
"""
function create_skippable_frame(user_data::AbstractVector{UInt8}, magic_number::UInt32=0x184D2A50)
    @assert magic_number ∈ 0x184D2A50:0x184D2A5F
    UInt8[
        reinterpret(UInt8, [htol(magic_number)]);
        reinterpret(UInt8, [htol(UInt32(length(user_data)))]);
        user_data;
    ]
end
