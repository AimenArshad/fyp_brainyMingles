import Link from '../Models/Link.js';

const uploadLink = async (req, res) => {
    try {
        const { url, altText, course, topic } = req.body;
        const email = req.body.email;
        const link = new Link({ url, altText, course, topic, uploadedBy: email });
        await link.save();
        res.status(200).json({ message: 'Link uploaded successfully', link });
    } catch (error) {
        console.error('Error uploading link:', error);
        res.status(500).json({ error: 'Failed to upload link' });
    }
  };

  const getLinks = async (req, res) => {
      try {
          const links = await Link.find();
          res.status(200).json(links);
      } catch (error) {
          console.error('Error fetching links:', error);
          res.status(500).json({ error: 'Failed to fetch links' });
      }
  };

  const getLinksByEmail = async (req, res) => {
    try {
      const email = req.body.email;
      const links = await Link.find({ uploadedBy: email });
      res.status(200).json(links);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  }
  
  const deleteLink = async (req, res) => {
    const linkId = req.params.id;
  
    try {
      const link = await Link.findById(linkId);
  
      if (!link) {
        return res.status(404).json({ error: 'Link not found' });
      }
      await link.deleteOne();
      res.status(200).json({ message: 'Link deleted successfully' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'An error occurred while deleting the link' });
    }
  }
  

  export {uploadLink, getLinks, getLinksByEmail, deleteLink}