//
//  ConnectionHandler.hpp
//  MarvinCpp
//
//  Created by ROBERT BLACKWELL on 12/12/16.
//  Copyright © 2016 Blackwellapps. All rights reserved.
//

#ifndef CONNECTION_HANDLER_HPP
#define CONNECTION_HANDLER_HPP

#include <stdio.h>
#include <boost/asio.hpp>

#include "message_reader.hpp"
#include "message_writer.hpp"
#include "connection_interface.hpp"
#include "server_connection_manager.hpp"


//
// If these are defined we use unique_ptr to hold Connection, MessageReader, MessageWriter
//
#define CH_SMARTPOINTER
#define CON_SMARTPOINTER
/// TRequestHandler must conform to RequestHandlerBase
template<class TRequestHandler> class ConnectionHandler
{
    public:
        ConnectionHandler(
            boost::asio::io_service&                        io,
            ServerConnectionManager<ConnectionHandler<TRequestHandler>>&     connectionManager,
            ConnectionInterface*                                     conn
        );
    
        ~ConnectionHandler();
    
        void serve();
        void close();
        long nativeSocketFD();
    private:
    
        void serveAnother();
        void readMessageHandler(Marvin::ErrorType& err);
        void requestComplete(Marvin::ErrorType& err, bool keepAlive);
        void handlerComplete(Marvin::ErrorType& err);
        void handleConnectComplete(bool hijack);

    
        boost::asio::io_service&                            _io;
//        boost::asio::strand&                                _serverStrand;
        ConnectionInterface*                                _conn;
        ServerConnectionManager<ConnectionHandler>&         _connectionManager;
        TRequestHandler*                                    _requestHandlerPtr;
        std::unique_ptr<TRequestHandler>                    _requestHandlerUnPtr;
    
#ifdef CON_SMARTPOINTER
        ConnectionInterfaceSPtr                             _connection;
#else
        ConnectionInterface*                         _connection;
#endif

#ifdef CH_SMARTPOINTER
        MessageReaderSPtr   _reader;
        MessageWriterSPtr   _writer;
#else
        MessageReader*      _reader;
        MessageWriter*      _writer;
#endif
};

#include "connection_handler.ipp"

#endif /* ConnectionHandler_hpp */
