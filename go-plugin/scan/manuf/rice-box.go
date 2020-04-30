package manuf

import (
	"time"

	"github.com/GeertJohan/go.rice/embedded"
)

func init() {

	// define files
	file2 := &embedded.EmbeddedFile{
		Filename:    "manuf",
		FileModTime: time.Unix(1588210993, 0),

	}

	// define dirs
	dir1 := &embedded.EmbeddedDir{
		Filename:   "",
		DirModTime: time.Unix(1588210993, 0),
		ChildFiles: []*embedded.EmbeddedFile{
			file2, // "manuf"

		},
	}

	// link ChildDirs
	dir1.ChildDirs = []*embedded.EmbeddedDir{}

	// register embeddedBox
	embedded.RegisterEmbeddedBox(`./data`, &embedded.EmbeddedBox{
		Name: `./data`,
		Time: time.Unix(1588210993, 0),
		Dirs: map[string]*embedded.EmbeddedDir{
			"": dir1,
		},
		Files: map[string]*embedded.EmbeddedFile{
			"manuf": file2,
		},
	})
}