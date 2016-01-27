# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160125222143) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affiliations", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "department_id"
    t.integer  "year_from"
    t.integer  "year_to"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "affiliations", ["department_id"], name: "index_affiliations_on_department_id", using: :btree
  add_index "affiliations", ["person_id", "department_id"], name: "index_affiliations_on_person_id_and_department_id", unique: true, using: :btree
  add_index "affiliations", ["person_id"], name: "index_affiliations_on_person_id", using: :btree

  create_table "article_revisions", force: :cascade do |t|
    t.integer  "submission_id"
    t.integer  "version",       default: 1
    t.date     "received"
    t.integer  "pages"
    t.integer  "pictures",      default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "code",          default: "tekst_"
    t.string   "article"
  end

  add_index "article_revisions", ["submission_id"], name: "index_article_revisions_on_submission_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string  "status"
    t.string  "DOI"
    t.integer "issue_id"
    t.integer "submission_id"
  end

  add_index "articles", ["issue_id"], name: "index_articles_on_issue_id", using: :btree
  add_index "articles", ["submission_id"], name: "index_articles_on_submission_id", using: :btree

  create_table "authorships", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "submission_id"
    t.boolean  "corresponding", default: true
    t.integer  "position",      default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "authorships", ["person_id", "submission_id"], name: "index_authorships_on_person_id_and_submission_id", unique: true, using: :btree
  add_index "authorships", ["person_id"], name: "index_authorships_on_person_id", using: :btree
  add_index "authorships", ["submission_id"], name: "index_authorships_on_submission_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.integer  "institution_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "departments", ["institution_id"], name: "index_departments_on_institution_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "institutions", force: :cascade do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "acronym"
  end

  add_index "institutions", ["country_id"], name: "index_institutions_on_country_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.integer  "year"
    t.integer  "volume"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "prepared",   default: false
    t.boolean  "published",  default: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "name",                    null: false
    t.string   "surname",                 null: false
    t.string   "email",                   null: false
    t.string   "degree"
    t.string   "discipline",              null: false
    t.string   "orcid"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "roles",      default: [], null: false, array: true
    t.string   "sex"
    t.string   "photo"
    t.text     "competence"

  end

  add_index "people", ["email"], name: "index_people_on_email", using: :btree
  add_index "people", ["surname"], name: "index_people_on_surname", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "article_revision_id"
    t.string   "status"
    t.date     "asked"
    t.date     "deadline"
    t.text     "content"
    t.text     "remarks"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "reviews", ["article_revision_id"], name: "index_reviews_on_article_revision_id", using: :btree
  add_index "reviews", ["person_id"], name: "index_reviews_on_person_id", using: :btree

  create_table "storytime_actions", force: :cascade do |t|
    t.string   "name"
    t.string   "guid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storytime_actions", ["guid"], name: "index_storytime_actions_on_guid", using: :btree

  create_table "storytime_autosaves", force: :cascade do |t|
    t.text     "content"
    t.integer  "autosavable_id"
    t.string   "autosavable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  add_index "storytime_autosaves", ["autosavable_type", "autosavable_id"], name: "autosavable_index", using: :btree
  add_index "storytime_autosaves", ["site_id"], name: "index_storytime_autosaves_on_site_id", using: :btree

  create_table "storytime_comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  add_index "storytime_comments", ["post_id"], name: "index_storytime_comments_on_post_id", using: :btree
  add_index "storytime_comments", ["site_id"], name: "index_storytime_comments_on_site_id", using: :btree
  add_index "storytime_comments", ["user_id"], name: "index_storytime_comments_on_user_id", using: :btree

  create_table "storytime_media", force: :cascade do |t|
    t.string   "file"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  add_index "storytime_media", ["site_id"], name: "index_storytime_media_on_site_id", using: :btree
  add_index "storytime_media", ["user_id"], name: "index_storytime_media_on_user_id", using: :btree

  create_table "storytime_memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "storytime_role_id"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storytime_memberships", ["site_id"], name: "index_storytime_memberships_on_site_id", using: :btree
  add_index "storytime_memberships", ["storytime_role_id"], name: "index_storytime_memberships_on_storytime_role_id", using: :btree
  add_index "storytime_memberships", ["user_id"], name: "index_storytime_memberships_on_user_id", using: :btree

  create_table "storytime_permissions", force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  add_index "storytime_permissions", ["action_id"], name: "index_storytime_permissions_on_action_id", using: :btree
  add_index "storytime_permissions", ["role_id"], name: "index_storytime_permissions_on_role_id", using: :btree
  add_index "storytime_permissions", ["site_id"], name: "index_storytime_permissions_on_site_id", using: :btree

  create_table "storytime_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.text     "excerpt"
    t.datetime "published_at"
    t.integer  "featured_media_id"
    t.boolean  "featured",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "secondary_media_id"
    t.integer  "site_id"
    t.boolean  "notifications_enabled", default: false
    t.datetime "notifications_sent_at"
    t.integer  "blog_id"
  end

  add_index "storytime_posts", ["blog_id"], name: "index_storytime_posts_on_blog_id", using: :btree
  add_index "storytime_posts", ["slug"], name: "index_storytime_posts_on_slug", using: :btree
  add_index "storytime_posts", ["user_id"], name: "index_storytime_posts_on_user_id", using: :btree

  create_table "storytime_roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storytime_roles", ["name"], name: "index_storytime_roles_on_name", using: :btree

  create_table "storytime_sites", force: :cascade do |t|
    t.string   "title"
    t.integer  "post_slug_style",         default: 0
    t.string   "ga_tracking_id"
    t.integer  "root_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subscription_email_from"
    t.string   "layout"
    t.string   "disqus_forum_shortname"
    t.integer  "user_id"
    t.string   "custom_domain"
    t.string   "discourse_name"
  end

  add_index "storytime_sites", ["root_post_id"], name: "index_storytime_sites_on_root_post_id", using: :btree
  add_index "storytime_sites", ["user_id"], name: "index_storytime_sites_on_user_id", using: :btree

  create_table "storytime_snippets", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  add_index "storytime_snippets", ["name"], name: "index_storytime_snippets_on_name", using: :btree

  create_table "storytime_subscriptions", force: :cascade do |t|
    t.string   "email"
    t.boolean  "subscribed", default: true
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  add_index "storytime_subscriptions", ["token"], name: "index_storytime_subscriptions_on_token", using: :btree

  create_table "storytime_taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  add_index "storytime_taggings", ["post_id"], name: "index_storytime_taggings_on_post_id", using: :btree
  add_index "storytime_taggings", ["site_id"], name: "index_storytime_taggings_on_site_id", using: :btree
  add_index "storytime_taggings", ["tag_id"], name: "index_storytime_taggings_on_tag_id", using: :btree

  create_table "storytime_tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  create_table "storytime_versions", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "versionable_id"
    t.string   "versionable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  add_index "storytime_versions", ["site_id"], name: "index_storytime_versions_on_site_id", using: :btree
  add_index "storytime_versions", ["user_id"], name: "index_storytime_versions_on_user_id", using: :btree
  add_index "storytime_versions", ["versionable_type", "versionable_id"], name: "versionable_index", using: :btree

  create_table "submissions", force: :cascade do |t|
    t.string   "status"
    t.string   "polish_title"
    t.string   "english_title"
    t.text     "english_abstract"
    t.string   "english_keywords"
    t.text     "remarks"
    t.text     "funding"
    t.date     "received"
    t.string   "language"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "person_id"
    t.integer  "issue_id"
  end

  add_index "submissions", ["issue_id"], name: "index_submissions_on_issue_id", using: :btree
  add_index "submissions", ["person_id"], name: "index_submissions_on_person_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "storytime_name"
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "affiliations", "departments"
  add_foreign_key "affiliations", "people"
  add_foreign_key "article_revisions", "submissions"
  add_foreign_key "articles", "issues"
  add_foreign_key "articles", "submissions"
  add_foreign_key "authorships", "people"
  add_foreign_key "authorships", "submissions"
  add_foreign_key "departments", "institutions"
  add_foreign_key "institutions", "countries"
  add_foreign_key "reviews", "article_revisions"
  add_foreign_key "reviews", "people"
  add_foreign_key "submissions", "issues"
  add_foreign_key "submissions", "people"
end
