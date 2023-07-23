defmodule EmployeeManagementSystem.GroupMembersTest do
  use EmployeeManagementSystem.DataCase

  alias EmployeeManagementSystem.GroupMembers

  describe "group_members" do
    alias EmployeeManagementSystem.GroupMembers.GroupMember

    import EmployeeManagementSystem.GroupMembersFixtures

    @invalid_attrs %{member: nil}

    test "list_group_members/0 returns all group_members" do
      group_member = group_member_fixture()
      assert GroupMembers.list_group_members() == [group_member]
    end

    test "get_group_member!/1 returns the group_member with given id" do
      group_member = group_member_fixture()
      assert GroupMembers.get_group_member!(group_member.id) == group_member
    end

    test "create_group_member/1 with valid data creates a group_member" do
      valid_attrs = %{member: "some member"}

      assert {:ok, %GroupMember{} = group_member} = GroupMembers.create_group_member(valid_attrs)
      assert group_member.member == "some member"
    end

    test "create_group_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GroupMembers.create_group_member(@invalid_attrs)
    end

    test "update_group_member/2 with valid data updates the group_member" do
      group_member = group_member_fixture()
      update_attrs = %{member: "some updated member"}

      assert {:ok, %GroupMember{} = group_member} =
               GroupMembers.update_group_member(group_member, update_attrs)

      assert group_member.member == "some updated member"
    end

    test "update_group_member/2 with invalid data returns error changeset" do
      group_member = group_member_fixture()

      assert {:error, %Ecto.Changeset{}} =
               GroupMembers.update_group_member(group_member, @invalid_attrs)

      assert group_member == GroupMembers.get_group_member!(group_member.id)
    end

    test "delete_group_member/1 deletes the group_member" do
      group_member = group_member_fixture()
      assert {:ok, %GroupMember{}} = GroupMembers.delete_group_member(group_member)
      assert_raise Ecto.NoResultsError, fn -> GroupMembers.get_group_member!(group_member.id) end
    end

    test "change_group_member/1 returns a group_member changeset" do
      group_member = group_member_fixture()
      assert %Ecto.Changeset{} = GroupMembers.change_group_member(group_member)
    end
  end
end
