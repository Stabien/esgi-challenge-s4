package fixtures

import (
	"easynight/internal/models"
	"time"

	"github.com/google/uuid"

	"easynight/pkg/utils"
)

var participantNumber = 30

// Base Users
var Events = []models.Event{
	{
		ID:                uuid.New(),
		Title:             "Soirée disco",
		Description:       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
		Banner:            "https://erasmusplace.com/wp-content/uploads/listing-uploads/cover/2020/11/81560978_545938166006717_7586927301657362432_o.jpg",
		Image:             "https://erasmusplace.com/wp-content/uploads/listing-uploads/cover/2020/11/81560978_545938166006717_7586927301657362432_o.jpg",
		Date:              time.Date(2024, time.July, 22, 0, 0, 0, 0, time.Local),
		ParticipantNumber: &participantNumber,
		Lat:               48.83,
		Lng:               2.31,
		Location:          "3 Place Denfert-Rochereau, Paris 75014",
		Place:             "Café Oz The Australian Bar Denfert",
		Tag:               "Disco",
		Organizers:        []models.Organizer{Organizers[0], Organizers[1], Organizers[2]},
		Code:              utils.GenerateRandomString(6),
	},
	{
		ID:                uuid.New(),
		Title:             "Jazz Bar",
		Description:       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
		Banner:            "https://www.parisjazzclub.net/medias/photos_lieux/687-caveau-de-la-huchette-1/images/caveau-de-la-huchette-1-lg.jpg?20190308085451",
		Image:             "https://www.parisjazzclub.net/medias/photos_lieux/687-caveau-de-la-huchette-1/images/caveau-de-la-huchette-1-lg.jpg?20190308085451",
		Date:              time.Date(2024, time.July, 15, 0, 0, 0, 0, time.Local),
		ParticipantNumber: &participantNumber,
		Lat:               48.85,
		Lng:               2.34,
		Location:          "5 Rue de la Huchette, 75005 Paris",
		Place:             "Le Caveau de la Huchette",
		Tag:               "Jazz",
		Organizers:        []models.Organizer{Organizers[1]},
		Code:              utils.GenerateRandomString(6),
	},
	{
		ID:                uuid.New(),
		Title:             "Joachim Pastor",
		Description:       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
		Banner:            "https://www.villaschweppes.com/app/uploads/2019/12/345463-le-t7-place-des-insurges-de-varsovie-orig-2.jpg",
		Image:             "https://www.villaschweppes.com/app/uploads/2019/12/345463-le-t7-place-des-insurges-de-varsovie-orig-2.jpg",
		Date:              time.Date(2024, time.July, 19, 0, 0, 0, 0, time.Local),
		ParticipantNumber: &participantNumber,
		Lat:               48.82,
		Lng:               2.29,
		Location:          "Place des Insurgés de Varsovie, 75015 Paris",
		Place:             "T7 Club",
		Tag:               "Techno",
		Organizers:        []models.Organizer{Organizers[2]},
		Code:              utils.GenerateRandomString(6),
	},
}
