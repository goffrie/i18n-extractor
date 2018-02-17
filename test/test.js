const extract = require('../lib/extract');
const assert = require('assert');

function extractArray(js, options) {
    options.warnings = options.warnings || [];
    const r = extract(js, options);
    assert.deepEqual(options.warnings, []);
    return (Object.keys(r['']) || '').sort();
}

describe('extract', () => {
    it('should detect i18n', () => {
        const result = extractArray(
            `
                function a() {
                    i18n("a");
                }
                i18n('b');
            `,
            { fun: 'i18n' }
        );
        assert.deepEqual(result, ['a', 'b']);
    });

    it('should not look into comments', () => {
        const result = extractArray(
            `
                function a() {
                    i18n('c'); // i18n("a");
                }
                /* i18n('b'); */
                i18n('d');
            `,
            { fun: 'i18n' }
        );
        assert.deepEqual(result, ['c', 'd']);
    });

    it('should not look into strings', () => {
        const result = extractArray(
            `
                "i18n('hello')"
                function a() {
                    i18n('i18n("what a trap")');
                }
            `,
            { fun: 'i18n' }
        );
        assert.deepEqual(result, ['i18n("what a trap")']);
    });

    it('should produce warnings', () => {
        warnings = [];
        const r = extract(
            `
                i18n(non_constant);
                i18n(function() { return "what is going on" });
                i18n(1);
                i18n('ok');
                i18n();
            `,
            {fun: 'i18n', warnings}
        );
        assert.equal(warnings.length, 4);
        assert.deepEqual(Object.keys(r[""]), ['ok']);
    });

    it('should work on constant expressions', () => {
        const result = extractArray("i18n('i' + ' am' + ' a' + ' string')", {fun: 'i18n'});
        assert.deepEqual(result, ['i am a string']);
    });

    it('should allow multiple arguments', () => {
        const result = extractArray("i18n('hello %s', notConstant)", {fun: 'i18n'});
        assert.deepEqual(result, ['hello %s']);
    });

    // it('should work with es6', () => {
    //     const result = extractArray(
    //         `
    //             const x = 7;
    //             const a = () => {
    //                 i18n("a");
    //             };

    //             async function() {
    //                 i18n('b');
    //             }
    //         `,
    //         { fun: 'i18n' }
    //     );
    //     assert.deepEqual(result, ['a', 'b']);
    // });
});
