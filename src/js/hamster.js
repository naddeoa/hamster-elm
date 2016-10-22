const Promise = require('promise');
const dbus = require('dbus-native');

const serviceName = 'org.gnome.Hamster';
const interfaceName = serviceName;
const objectPath = '/org/gnome/Hamster';
const sessionBus = dbus.sessionBus();

if (!sessionBus) {
    throw new Error('Could not connect to the DBus session bus.')
}
const hamsterService = sessionBus.getService(serviceName);
const hamsterApi = Promise.denodeify(hamsterService.getInterface.bind(hamsterService, objectPath, interfaceName));

const getCall = (apiGetter) => () => hamsterApi().then(api => Promise.denodeify(apiGetter(api)));
const getTagsCall = getCall(api => api.GetTags.bind(api, true));

class Hamster {

    getTags() {
        return getTagsCall()
          .then(tagsCall => tagsCall())
          .then(tags => tags.map(tagResult => ({id: tagResult[0], name: tagResult[1]})))
          .catch(err => err);

    }
}
// hamsterApi().then(api => console.log(api));
// new Hamster().getTags().then(tags => console.log(tags));
module.exports = Hamster;
