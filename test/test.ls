require! {
    extract: '..'
    assert
}
{ keys, sort } = require \prelude-ls

extractArray = (js, opts) ->
    opts.warnings ?= []
    r = extract js, opts
    assert.deepEqual opts.warnings, []
    sort keys r[''] ? ''

_it = it

<- describe 'extract'

_it 'should detect i18n' ->
    assert.deepEqual extractArray do
        """
        function a() {
            i18n("a");
        }
        i18n('b');
        """
        { fun: 'i18n' }
    , ['a', 'b']

_it 'should not look into comments' ->
    assert.deepEqual extractArray do
        """
        function a() {
            i18n('c'); // i18n("a");
        }
        /* i18n('b'); */
        i18n('d');
        """
        { fun: 'i18n' }
    , ['c', 'd']

_it 'should not look into strings' ->
    assert.deepEqual extractArray do
        """
        "i18n('hello')"
        function a() {
            i18n('i18n("what a trap")');
        }
        """
        { fun: 'i18n' }
    , ['i18n("what a trap")']

_it 'should produce warnings' ->
    warnings = []
    r = extract do
        """
        i18n(non_constant);
        i18n(function() { return "what is going on" });
        i18n(1);
        i18n('ok');
        i18n();
        """
        { fun: 'i18n', warnings }
    assert.equal warnings.length, 4
    assert.deepEqual keys(r[""]), ['ok']

_it 'should work on constant expressions' ->
    assert.deepEqual extractArray do
        """
        i18n('i' + ' am' + ' a' + ' string')
        """
        { fun: 'i18n' }
    , ['i am a string']

_it 'should allow multiple arguments' ->
    assert.deepEqual extractArray do
        """
        i18n('hello %s', notConstant)
        """
        { fun: 'i18n' }
    , ['hello %s']
