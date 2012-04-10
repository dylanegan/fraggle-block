# Fraggle::Block

A synchronous Ruby client for [Doozer](https://github.com/ha/doozer). 

## Install

    $ gem install fraggle-block

## Use

    >> require 'rubygems'
    >> require 'fraggle/block'
    >> client = Fraggle::Block.connect
    => #<Fraggle::Block::Client:0x10217b260 @connection=#<Fraggle::Block::Connection:0x10217bbc0 @cn=#<TCPSocket:0x10217b3c8>, host"127.0.0.1", port8046
    >> client.set('/foo', 'test', 0)
    => Fraggle::Block::Response tag: 0, flags: 3, rev: 482
    >> foo = client.get('/foo')
    => Fraggle::Block::Response value: "test", tag: 0, flags: 3, rev: 482
    >> foo = client.getdir('/')
    => [Fraggle::Block::Response path: "foo", tag: 0, flags: 1, Fraggle::Block::Response path: "ctl", tag: 0, flags: 1, Fraggle::Block::Response tag: 0, flags: 2]
    >> foo = client.del('/foo', 482)
    => Fraggle::Block::Response tag: 0, flags: 3
    >> client.disconnect
    => nil 

See [examples](https://github.com/dylanegan/fraggle-block/tree/master/examples) for more.


# Generate ProtoBuf code

BEEFCAKE_NAMESPACE=Fraggle::Block protoc --beefcake_out lib/fraggle/block/ -I .  msg.proto

