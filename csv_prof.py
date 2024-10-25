import csv
import sys
import os


def one_csv(csv_file):
    """Analyse one file

    Args:
        csv_file ([str]): filename
    """
    with open(csv_file, mode='r', encoding='iso-8859-2') as file:
        reader = csv.reader(file, delimiter=';', quotechar='"')

    # Read header
        headers = next(reader)

    # Init max length
        max_lengths = [0] * len(headers)

    # read lines
        for row in reader:
            for i, field in enumerate(row):
                if field:  # Check if empty
                    max_lengths[i] = max(max_lengths[i], len(field))

    # results write to file
        with open("max_field_lengths.txt", "a") as output_file:
            for i, header in enumerate(headers):
                max_length = max_lengths[i]
                if isinstance(max_length, int):
                    output_file.write(f"{csv_file};{header};{max_length}\n")
                else:
                    output_file.write(f"{csv_file};{header};N/A\n")


def main():
    """Main entry point
    """

    if len(sys.argv) < 2:
        print("First parameter is the folder name !")
        sys.exit(1)
    folder_path = sys.argv[1]
    csv_files = [f for f in os.listdir(folder_path) if f.endswith('.csv')]

    for csv_file in csv_files:
        one_csv(folder_path+csv_file)


if __name__ == "__main__":
    main()
