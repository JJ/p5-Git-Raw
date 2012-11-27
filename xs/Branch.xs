MODULE = Git::Raw			PACKAGE = Git::Raw::Branch

BOOT:
{
    AV *isa = perl_get_av("Git::Raw::Branch::ISA",1);
    av_push(isa, newSVpv("Git::Raw::Reference", 0));
}

Branch
create(class, repo, name, target)
	SV *class
	Repository repo
	SV *name
	SV *target

	CODE:
		Reference out;
		const char *name_str = SvPVbyte_nolen(name);

		git_object *obj = git_sv_to_obj(target);

		int rc = git_branch_create(&out, repo, name_str, obj, 0);
		git_check_error(rc);

		RETVAL = out;

	OUTPUT: RETVAL

Branch
lookup(class, repo, name, is_local)
	SV *class
	Repository repo
	SV *name
	bool is_local

	CODE:
		Reference b;
		git_branch_t t = is_local ?
			GIT_BRANCH_LOCAL     :
			GIT_BRANCH_REMOTE    ;

		int rc = git_branch_lookup(&b, repo, SvPVbyte_nolen(name), t);
		git_check_error(rc);

		RETVAL = b;

	OUTPUT: RETVAL

void
foreach(class, repo, cb)
	SV *class
	Repository repo
        SV *cb
	CODE:
                git_branch_foreach_payload payload;
                payload.repo = repo;
                payload.cb = cb;

		int rc = git_branch_foreach(repo, GIT_BRANCH_LOCAL|GIT_BRANCH_REMOTE, git_branch_foreach_cb, &payload);
                if (rc && rc != GIT_EUSER)
                    git_check_error(rc);
