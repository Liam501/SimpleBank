package gapi

import (
	"fmt"

	db "github.com/Liam501/SimpleBank/db/sqlc"
	"github.com/Liam501/SimpleBank/pb"
	"github.com/Liam501/SimpleBank/token"
	"github.com/Liam501/SimpleBank/util"
)

// Server servers gRPC requests for the banking service.
type Server struct {
	pb.UnimplementedSimpleBankServer
	config     util.Config
	store      db.Store
	tokenMaker token.Maker
}

// NewServer creates a new gRPC server.
func NewServer(config util.Config, store db.Store) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}
	server := &Server{
		config:     config,
		store:      store,
		tokenMaker: tokenMaker,
	}

	return server, nil
}
