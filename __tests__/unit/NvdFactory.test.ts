import { Vulnerability } from "../../src/core/entities/types/Vulnerability";
import { VulnerabilityFactory } from "../../src/core/factories/NvdFactory";

describe("VulnerabilityFactory class test suit", () => {
  const itemJSON = 
    {
      cve: {
        id: "CVE-2017-5932",
        sourceIdentifier: "secalert@redhat.com",
        published: "2017-03-27T15:59:00.590",
        lastModified: "2024-11-21T03:28:41.833",
        vulnStatus: "Modified",
        cveTags: [],
        descriptions: [
          {
            lang: "en",
            value:
              'The path autocompletion feature in Bash 4.4 allows local users to gain privileges via a crafted filename starting with a " (double quote) character and a command substitution metacharacter.',
          },
          {
            lang: "es",
            value:
              'La funcionalidad de autocompletar de ruta en Bash 4.4 permite usuarios locales obtener privilegios a través de nombre de archivo manipulado empezando con un carácter "(comillas dobles) y un metacaracter de sustitución de comandos.',
          },
        ],
        metrics: {
          cvssMetricV30: [
            {
              source: "nvd@nist.gov",
              type: "Primary",
              cvssData: {
                version: "3.0",
                vectorString: "CVSS:3.0/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H",
                baseScore: 7.8,
                baseSeverity: "HIGH",
                attackVector: "LOCAL",
                attackComplexity: "LOW",
                privilegesRequired: "LOW",
                userInteraction: "NONE",
                scope: "UNCHANGED",
                confidentialityImpact: "HIGH",
                integrityImpact: "HIGH",
                availabilityImpact: "HIGH",
              },
              exploitabilityScore: 1.8,
              impactScore: 5.9,
            },
          ],
          cvssMetricV2: [
            {
              source: "nvd@nist.gov",
              type: "Primary",
              cvssData: {
                version: "2.0",
                vectorString: "AV:L/AC:L/Au:N/C:P/I:P/A:P",
                baseScore: 4.6,
                accessVector: "LOCAL",
                accessComplexity: "LOW",
                authentication: "NONE",
                confidentialityImpact: "PARTIAL",
                integrityImpact: "PARTIAL",
                availabilityImpact: "PARTIAL",
              },
              baseSeverity: "MEDIUM",
              exploitabilityScore: 3.9,
              impactScore: 6.4,
              acInsufInfo: true,
              obtainAllPrivilege: false,
              obtainUserPrivilege: false,
              obtainOtherPrivilege: false,
              userInteractionRequired: false,
            },
          ],
        },
        weaknesses: [
          {
            source: "nvd@nist.gov",
            type: "Primary",
            description: [
              {
                lang: "en",
                value: "CWE-20",
              },
            ],
          },
        ],
        configurations: [
          {
            nodes: [
              {
                operator: "OR",
                negate: false,
                cpeMatch: [
                  {
                    vulnerable: true,
                    criteria: "cpe:2.3:a:gnu:bash:4.4:*:*:*:*:*:*:*",
                    matchCriteriaId: "1A9044AB-025E-4765-BFC2-5ADFD0522131",
                  },
                ],
              },
            ],
          },
        ],
        references: [
          {
            url: "http://git.savannah.gnu.org/cgit/bash.git/commit/?id=4f747edc625815f449048579f6e65869914dd715",
            source: "secalert@redhat.com",
            tags: ["Patch", "Third Party Advisory"],
          },
          {
            url: "http://www.openwall.com/lists/oss-security/2017/02/08/3",
            source: "secalert@redhat.com",
            tags: ["Mailing List", "Patch", "Third Party Advisory"],
          },
          {
            url: "http://www.securityfocus.com/bid/96136",
            source: "secalert@redhat.com",
            tags: ["Third Party Advisory", "VDB Entry"],
          },
          {
            url: "https://lists.gnu.org/archive/html/bug-bash/2017-01/msg00034.html",
            source: "secalert@redhat.com",
            tags: ["Mailing List", "Patch", "Vendor Advisory"],
          },
          {
            url: "http://git.savannah.gnu.org/cgit/bash.git/commit/?id=4f747edc625815f449048579f6e65869914dd715",
            source: "af854a3a-2127-422b-91ae-364da2661108",
            tags: ["Patch", "Third Party Advisory"],
          },
          {
            url: "http://www.openwall.com/lists/oss-security/2017/02/08/3",
            source: "af854a3a-2127-422b-91ae-364da2661108",
            tags: ["Mailing List", "Patch", "Third Party Advisory"],
          },
          {
            url: "http://www.securityfocus.com/bid/96136",
            source: "af854a3a-2127-422b-91ae-364da2661108",
            tags: ["Third Party Advisory", "VDB Entry"],
          },
          {
            url: "https://lists.gnu.org/archive/html/bug-bash/2017-01/msg00034.html",
            source: "af854a3a-2127-422b-91ae-364da2661108",
            tags: ["Mailing List", "Patch", "Vendor Advisory"],
          },
        ],
      },
    };
  describe("create", () => {
    it("should return the vulnerability object", () => {
        const result =  VulnerabilityFactory.create(itemJSON);
        expect(result).not.toBeNull();
        expect(result?.cveId).toEqual("CVE-2017-5932");
    });
  });
});
