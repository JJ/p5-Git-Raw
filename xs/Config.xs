MODULE = Git::Raw			PACKAGE = Git::Raw::Config

SV *
string(self, name, ...)
	Config self
	SV *name

	CODE:
		int rc;
		STRLEN len;
		const char *value;
		const char *var = SvPVbyte(name, len);

		switch (items) {
			case 2: {
				rc = git_config_get_string(&value, self, var);
				git_check_error(rc);

				break;
			}

			case 3: {
				STRLEN len2;
				value = SvPVbyte(ST(2), len2);

				rc = git_config_set_string(self, var, value);
				git_check_error(rc);

				break;
			}

			default: Perl_croak(aTHX_ "Too much arguments");
		}

		RETVAL = newSVpv(value, 0);

	OUTPUT: RETVAL

void
DESTROY(self)
	Config self

	CODE:
		git_config_free(self);
