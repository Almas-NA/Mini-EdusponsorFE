import 'package:edusponsor/admin/cubits/institutions/allinstitutioncubit/allinstitution_cubit.dart';
import 'package:edusponsor/sponsor/components/instsponsorships.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SponsorInstitutions extends StatefulWidget {
  const SponsorInstitutions({super.key});

  @override
  State<SponsorInstitutions> createState() => _SponsorInstitutionsState();
}

class _SponsorInstitutionsState extends State<SponsorInstitutions> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    context.read<AllinstitutionCubit>().getAllInstitutions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AllinstitutionCubit, AllinstitutionState>(
        builder: (context, state) {
          if (state is AllinstitutionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllinstitutionLoaded) {
            final institutions = state.institutions;

            if (institutions.isEmpty) {
              return const Center(child: Text("No institutions found"));
            }

            // Extract unique locations
            final locations = institutions
                .map((inst) => inst['location'] ?? "")
                .where((loc) => loc.isNotEmpty)
                .toSet()
                .toList();

            // Apply search & filter
            final filteredInstitutions = institutions.where((inst) {
              final matchesSearch =
                  searchQuery.isEmpty ||
                  (inst['instituteName'] ?? "").toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );

              final matchesLocation =
                  selectedLocation == null ||
                  inst['location'] == selectedLocation;

              return matchesSearch && matchesLocation;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          searchQuery = "";
                                          _searchController.clear();
                                        });
                                      },
                                    )
                                  : null,
                              hintText: "Search by institution name...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onChanged: (val) {
                              setState(() => searchQuery = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedLocation,
                              hint: const Text("Filter by Location"),
                              items: locations.map((loc) {
                                return DropdownMenuItem<String>(
                                  value: loc,
                                  child: Text(loc),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedLocation = value;
                                });
                              },
                            ),
                          ),
                        ),
                        if (selectedLocation != null)
                          IconButton(
                            icon: const Icon(Icons.clear, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                selectedLocation = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredInstitutions.length,
                    itemBuilder: (context, index) {
                      final institution = filteredInstitutions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              institution['instituteName'][0].toUpperCase(),
                            ),
                          ),
                          title: Text(institution['instituteName'] ?? ''),
                          subtitle: Text(institution['location'] ?? ''),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SponsorInstSponsorships(
                                  instID:
                                      institution['id'], 
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is AllinstitutionError) {
            return const Center(child: Text("Failed to load institutions"));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
