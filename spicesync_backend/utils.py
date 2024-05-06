import os

def generate_local_path(file_name):
    """
    Generate the local file path by combining the directory path of the current file
    with the given file name.

    Args:
        file_name (str): The name of the file.

    Returns:
        str: The local file path.

    """
    dir_path = os.path.dirname(os.path.realpath(__file__))
    file_path = os.path.join(dir_path, file_name)
    return file_path

