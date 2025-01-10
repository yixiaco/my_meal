CREATE TABLE "cookbook" (
  "cookbook_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "title" TEXT NOT NULL,
  "subtitle" TEXT,
  "cover_image_path" TEXT,
  "ingredients_json" TEXT NOT NULL,
  "step_json" TEXT NOT NULL,
  "update_time" DATE,
  "create_time" DATE
);