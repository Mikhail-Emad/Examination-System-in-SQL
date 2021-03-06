USE [master]
GO
/****** Object:  Database [ExaminationSystem]    Script Date: 1/29/2022 11:17:20 PM ******/
CREATE DATABASE [ExaminationSystem]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'projects_dat', FILENAME = N'F:\ITI\study\projects\SQL Project\DataFiles\projects_dat.mdf' , SIZE = 51200KB , MAXSIZE = UNLIMITED, FILEGROWTH = 102400KB )
 LOG ON 
( NAME = N'projects_log', FILENAME = N'F:\ITI\study\projects\SQL Project\DataFiles\projects_log.ldf' , SIZE = 10240KB , MAXSIZE = 2048GB , FILEGROWTH = 102400KB )
GO
ALTER DATABASE [ExaminationSystem] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ExaminationSystem].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ExaminationSystem] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ExaminationSystem] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ExaminationSystem] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ExaminationSystem] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ExaminationSystem] SET ARITHABORT OFF 
GO
ALTER DATABASE [ExaminationSystem] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ExaminationSystem] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ExaminationSystem] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ExaminationSystem] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ExaminationSystem] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ExaminationSystem] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ExaminationSystem] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ExaminationSystem] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ExaminationSystem] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ExaminationSystem] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ExaminationSystem] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ExaminationSystem] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ExaminationSystem] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ExaminationSystem] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ExaminationSystem] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ExaminationSystem] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ExaminationSystem] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ExaminationSystem] SET RECOVERY FULL 
GO
ALTER DATABASE [ExaminationSystem] SET  MULTI_USER 
GO
ALTER DATABASE [ExaminationSystem] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ExaminationSystem] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ExaminationSystem] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ExaminationSystem] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ExaminationSystem] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ExaminationSystem] SET QUERY_STORE = OFF
GO
USE [ExaminationSystem]
GO
/****** Object:  User [Training_Manager]    Script Date: 1/29/2022 11:17:20 PM ******/
CREATE USER [Training_Manager] FOR LOGIN [Training_Manager] WITH DEFAULT_SCHEMA=[Manager]
GO
/****** Object:  User [sys_admin]    Script Date: 1/29/2022 11:17:20 PM ******/
CREATE USER [sys_admin] FOR LOGIN [sys_admin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [student]    Script Date: 1/29/2022 11:17:20 PM ******/
CREATE USER [student] FOR LOGIN [student] WITH DEFAULT_SCHEMA=[student]
GO
/****** Object:  User [instructor]    Script Date: 1/29/2022 11:17:20 PM ******/
CREATE USER [instructor] FOR LOGIN [Instructor] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [sys_admin]
GO
/****** Object:  Schema [Instructor]    Script Date: 1/29/2022 11:17:21 PM ******/
CREATE SCHEMA [Instructor]
GO
/****** Object:  Schema [Manager]    Script Date: 1/29/2022 11:17:21 PM ******/
CREATE SCHEMA [Manager]
GO
/****** Object:  Schema [student]    Script Date: 1/29/2022 11:17:21 PM ******/
CREATE SCHEMA [student]
GO
USE [ExaminationSystem]
GO
/****** Object:  Sequence [dbo].[QuestNo_IN_Exam]    Script Date: 1/29/2022 11:17:21 PM ******/
CREATE SEQUENCE [dbo].[QuestNo_IN_Exam] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 7
 CACHE 
GO
/****** Object:  UserDefinedFunction [dbo].[checkExameWithCourse]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[checkExameWithCourse](@ExamID varchar(20),@CourseCode varchar(40),@InstrSSN char(14))
returns bit
begin
	Declare @Result bit
	Declare @SelectResult table (ExamID varchar(20),CourseCode varchar(40))
	insert into @SelectResult SELECT [ID],[CourseCode]  from [Instructor].[Exame]
	where [ID]=@ExamID and [CourseCode]=@CourseCode and [InstructorSSN]=@InstrSSN

	if @@ROWCOUNT>0
		set @Result=1
	else
		set @Result=0

	return @Result
end
GO
/****** Object:  UserDefinedFunction [dbo].[CheckInstWithCourse]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CheckInstWithCourse](@INSTSSN char(14),@CourseCode varchar(40),@ClassID int)
returns bit
begin
	declare @Res bit
	declare @SelectRes table([Instructor_SSN] char(14),CorseCode varchar(40),ClassID int);
	insert into @SelectRes Select * from [Manager].[CLS_CRS_INS] where [Instructor_SSN]=@INSTSSN and
	[Course_Code]=@CourseCode and [Class_ID]=@ClassID
	if @@ROWCOUNT>0
	set @res=1
	else
	set @Res=0
	return @Res
	
end
GO
/****** Object:  UserDefinedFunction [dbo].[CheckQuestWithCourse]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[CheckQuestWithCourse](@QuestID varchar(20),@CourseCode varchar(40))
returns int
begin
	Declare @Result int
	--Declare @SelectResult table (Question_ID varchar(20),CourseCode varchar(40))
	SELECT @Result= [Degree]  from [Instructor].[Question]
	where [ID]=@QuestID and [Course_Code]=@CourseCode
	return @Result
end
GO
/****** Object:  UserDefinedFunction [dbo].[CheckStudentInCourse]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CheckStudentInCourse](@studentSSN char(14),@CourseCode varchar(40))
	returns bit
	as
	begin
	Declare @Res bit
	Declare @StdInCourse varchar(14)
	select @StdInCourse = [student_SSN] from [Manager].[Course_For_Student] where
	[Course_Code]=@CourseCode
	if @@ROWCOUNT>0
	 set @Res=1
	else 
	 set @Res=0
	return @Res
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetCourseCode]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[GetCourseCode](@courseName varchar(100))
returns varchar(40)
as
begin
	Declare @Course_code varchar(40)
    select @Course_code=[Code] from [Manager].[Course] where [Name]=@courseName
	return @Course_code
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetCourseDegree]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[GetCourseDegree](@CourseCode varchar(40))
returns int
begin
declare @TotalDegree int
select  @TotalDegree =[Max_degree] from [Manager].[Course] where [Code]=@CourseCode
return @TotalDegree
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetExameID]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[GetExameID](@studentSSN varchar(14),@Course_code varchar(40))
returns varchar(20)
as
begin
declare @Exam_id varchar(20)
	Select  @Exam_id= [Exam_id] from [Instructor].[Student_Exame_in_Course] where
   [Student_SSN]=@studentSSN and [Course_code]=@Course_code and [Std_degree] is null
   return @Exam_id
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetExamsTotalDegree]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[GetExamsTotalDegree](@CourseCode varchar(40))
returns int
begin
declare @TotalDegree int
select  @TotalDegree =sum([Total_degree]) from [Instructor].[Exame] where [CourseCode]=@CourseCode
if @TotalDegree is null
set @TotalDegree=0
return @TotalDegree
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetQuestionsTotalDegreeInExam]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[GetQuestionsTotalDegreeInExam](@ExamID varchar(20))
returns int
begin
declare @TotalDegree int
--Declare @ExamDegree int
--select @ExamDegree = [Total_degree] from [Instructor].[Exame] where [ID]=@ExamID
select  @TotalDegree =sum([Quest_degree]) from [Instructor].[Question_Exam] where
[Exam_id]=@ExamID
if @TotalDegree is null
set @TotalDegree=0
return @TotalDegree
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetStudentExams]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[GetStudentExams](@studentSSN char(14))
returns @AllExams table(CourseName varchar(100),ExameID varchar(20),ExamDat date)
as
begin
	insert into @AllExams select C.Name as 'Course Name', E.[ID] as ExamID,E.Exame_date
	from [Instructor].[Exame] as E
	join [Manager].[Course] as C on E.[CourseCode] =C.Code
	join [Instructor].[Student_Exame_in_Course] as SEC on C.Code=SEC.[Course_code]
	where SEC.[Student_SSN]=@studentSSN 
	--and E.Exame_date=CAST( GETDATE() as date);
	
return
end
GO
/****** Object:  UserDefinedFunction [dbo].[selectQuestAnswers]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[selectQuestAnswers](@ExamID varchar(20))
returns @SelectedExame table(Question_no_IN_Exame int,
QuestText varchar(300),AnswerText varchar(300))
as
begin
insert into @SelectedExame select QS.[Question_no_IN_Exame],Q.text[Text],Ans.[Text] from 
   [Instructor].[Question_Exam] as QS join [Instructor].[Question] as Q
   on QS.[Question_id]=Q.ID join
  [Instructor].[Answer] as Ans on Q.ID=Ans.[Qestion_id]
  where QS.[Exam_id]=@ExamID
return
end
GO
/****** Object:  Table [Manager].[CLS_CRS_INS]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[CLS_CRS_INS](
	[Class_ID] [int] NOT NULL,
	[Course_Code] [varchar](40) NOT NULL,
	[Instructor_SSN] [char](14) NOT NULL,
 CONSTRAINT [CLS_CRS_INS_PK] PRIMARY KEY CLUSTERED 
(
	[Class_ID] ASC,
	[Course_Code] ASC,
	[Instructor_SSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Instructor]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Instructor](
	[SSN] [char](14) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Age] [int] NOT NULL,
	[Gender] [char](1) NOT NULL,
	[Address] [varchar](200) NOT NULL,
	[email] [varchar](50) NOT NULL,
 CONSTRAINT [Instructor_PK] PRIMARY KEY CLUSTERED 
(
	[SSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Course]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Course](
	[Code] [varchar](40) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Max_degree] [int] NOT NULL,
	[Min_degree] [int] NOT NULL,
	[Name] [varchar](100) NULL,
 CONSTRAINT [Course_PK] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Unique_Course_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Student]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Student](
	[SSN] [char](14) NOT NULL,
	[Name] [varchar](140) NOT NULL,
	[Age] [int] NOT NULL,
	[Gender] [char](1) NOT NULL,
	[Address] [varchar](200) NOT NULL,
	[Email] [varchar](200) NOT NULL,
	[Class_ID] [int] NOT NULL,
 CONSTRAINT [Student_PK] PRIMARY KEY CLUSTERED 
(
	[SSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Course_For_Student]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Course_For_Student](
	[Course_Code] [varchar](40) NOT NULL,
	[student_SSN] [char](14) NOT NULL,
	[Total_degree] [int] NULL,
 CONSTRAINT [Course_For_Student_PK] PRIMARY KEY CLUSTERED 
(
	[Course_Code] ASC,
	[student_SSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[StudentGenralInfo]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[StudentGenralInfo]
as
(
	select 
		  std.SSN as ID,std.[Name] 'StudentName',[Description] as CourseName ,Inst.[Name] as IstructorName
		  from [Manager].[Course] as course
		  join [Manager].[Course_For_Student]
		  on [Code]=[Course_Code] 
		  join [Manager].[Student] as std
		  on [student_SSN]= [SSN]
		  join [Manager].[CLS_CRS_INS] as CCI
		  on CCI.[Course_Code]=course.[Code]
		  join [Manager].[Instructor] as Inst
		  on CCI.Instructor_SSN= Inst.SSN			
)
------------

GO
/****** Object:  Table [Instructor].[Answer]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Instructor].[Answer](
	[ID] [varchar](50) NOT NULL,
	[Text] [varchar](300) NOT NULL,
	[Qestion_id] [varchar](20) NULL,
	[Correct] [bit] NULL,
 CONSTRAINT [AnswerPK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Instructor].[Exame]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Instructor].[Exame](
	[ID] [varchar](20) NOT NULL,
	[Type] [varchar](10) NOT NULL,
	[Total_degree] [int] NOT NULL,
	[Allowance_Option] [varchar](20) NULL,
	[Exame_date] [date] NOT NULL,
	[InstructorSSN] [char](14) NOT NULL,
	[ClassID] [int] NOT NULL,
	[CourseCode] [varchar](40) NOT NULL,
	[Start-time] [time](0) NOT NULL,
	[End-time] [time](0) NOT NULL,
	[year]  AS (datepart(year,[Exame_date])),
	[Deuration]  AS (datediff(minute,[Start-time],[End-time])),
	[Number_of_Question] [int] NULL,
 CONSTRAINT [Exam_PK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Instructor].[Question]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Instructor].[Question](
	[ID] [varchar](20) NOT NULL,
	[Text] [varchar](300) NOT NULL,
	[Type] [varchar](300) NOT NULL,
	[Degree] [int] NULL,
	[Course_Code] [varchar](40) NOT NULL,
 CONSTRAINT [QuestionPK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Instructor].[Question_Exam]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Instructor].[Question_Exam](
	[Exam_id] [varchar](20) NOT NULL,
	[Question_id] [varchar](20) NOT NULL,
	[Question_no_IN_Exame] [int] NOT NULL,
	[Quest_degree] [int] NOT NULL,
 CONSTRAINT [Question_ExamPK] PRIMARY KEY CLUSTERED 
(
	[Exam_id] ASC,
	[Question_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Question_Exam_Unique] UNIQUE NONCLUSTERED 
(
	[Exam_id] ASC,
	[Question_id] ASC,
	[Question_no_IN_Exame] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Instructor].[Student_Exame_in_Course]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Instructor].[Student_Exame_in_Course](
	[Course_code] [varchar](40) NOT NULL,
	[Student_SSN] [char](14) NOT NULL,
	[Exam_id] [varchar](20) NOT NULL,
	[Std_degree] [int] NULL,
 CONSTRAINT [Student_Exames_in_Course_PK] PRIMARY KEY CLUSTERED 
(
	[Course_code] ASC,
	[Student_SSN] ASC,
	[Exam_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Instructor].[Student_Exame_Question]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Instructor].[Student_Exame_Question](
	[Exam_id] [varchar](20) NOT NULL,
	[Student_SSN] [char](14) NOT NULL,
	[Quest_id] [varchar](20) NOT NULL,
	[Std_Answer] [char](1) NULL,
	[Result] [int] NULL,
 CONSTRAINT [Student_Exame_Question_PK] PRIMARY KEY CLUSTERED 
(
	[Exam_id] ASC,
	[Student_SSN] ASC,
	[Quest_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Account]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Account](
	[UserName] [varchar](100) NOT NULL,
	[Password] [varchar](20) NOT NULL,
	[User_SSN] [char](14) NOT NULL,
 CONSTRAINT [Account_PK] PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Branch]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Branch](
	[ID] [varchar](20) NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Location] [varchar](200) NOT NULL,
	[Phone] [char](11) NOT NULL,
	[Manager_SSN] [char](14) NULL,
 CONSTRAINT [BranchPK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Class]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Class](
	[ID] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[IntakeNumber] [int] NOT NULL,
	[Branch_ID] [varchar](20) NOT NULL,
	[Track_ID] [varchar](20) NOT NULL,
 CONSTRAINT [Class_PK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Class_unique] UNIQUE NONCLUSTERED 
(
	[IntakeNumber] ASC,
	[Branch_ID] ASC,
	[Track_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Department]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Department](
	[ID] [varchar](50) NOT NULL,
	[Name] [varchar](200) NOT NULL,
 CONSTRAINT [DepartmentPK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Department_Branch]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Department_Branch](
	[Branch_id] [varchar](20) NOT NULL,
	[Dept_id] [varchar](50) NOT NULL,
 CONSTRAINT [Department_BranchPK] PRIMARY KEY CLUSTERED 
(
	[Branch_id] ASC,
	[Dept_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Intake]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Intake](
	[Number] [int] NOT NULL,
	[Start_date] [date] NOT NULL,
	[End_date] [date] NOT NULL,
	[Duration]  AS (datediff(month,[Start_date],[End_date])),
 CONSTRAINT [IntakePK] PRIMARY KEY CLUSTERED 
(
	[Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Track]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Track](
	[ID] [varchar](20) NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Description] [varchar](200) NOT NULL,
 CONSTRAINT [Track_PK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Track_Course]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Track_Course](
	[Track_ID] [varchar](20) NOT NULL,
	[Course_Code] [varchar](40) NOT NULL,
 CONSTRAINT [Track_Course_PK] PRIMARY KEY CLUSTERED 
(
	[Track_ID] ASC,
	[Course_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Manager].[Works_on]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manager].[Works_on](
	[Branch_id] [varchar](20) NOT NULL,
	[Dept_id] [varchar](50) NOT NULL,
	[Inst_SSN] [char](14) NOT NULL,
 CONSTRAINT [Works_onPK] PRIMARY KEY CLUSTERED 
(
	[Branch_id] ASC,
	[Dept_id] ASC,
	[Inst_SSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Instructor].[Answer]  WITH CHECK ADD  CONSTRAINT [Answer_Qestion_id_FK] FOREIGN KEY([Qestion_id])
REFERENCES [Instructor].[Question] ([ID])
GO
ALTER TABLE [Instructor].[Answer] CHECK CONSTRAINT [Answer_Qestion_id_FK]
GO
ALTER TABLE [Instructor].[Exame]  WITH CHECK ADD  CONSTRAINT [Exame_ClassID_FK] FOREIGN KEY([ClassID])
REFERENCES [Manager].[Class] ([ID])
GO
ALTER TABLE [Instructor].[Exame] CHECK CONSTRAINT [Exame_ClassID_FK]
GO
ALTER TABLE [Instructor].[Exame]  WITH CHECK ADD  CONSTRAINT [Exame_CourseCode_FK] FOREIGN KEY([CourseCode])
REFERENCES [Manager].[Course] ([Code])
GO
ALTER TABLE [Instructor].[Exame] CHECK CONSTRAINT [Exame_CourseCode_FK]
GO
ALTER TABLE [Instructor].[Exame]  WITH CHECK ADD  CONSTRAINT [Exame_INSTR_SSN_FK] FOREIGN KEY([InstructorSSN])
REFERENCES [Manager].[Instructor] ([SSN])
GO
ALTER TABLE [Instructor].[Exame] CHECK CONSTRAINT [Exame_INSTR_SSN_FK]
GO
ALTER TABLE [Instructor].[Question]  WITH CHECK ADD  CONSTRAINT [Question_Course_Code_FK] FOREIGN KEY([Course_Code])
REFERENCES [Manager].[Course] ([Code])
GO
ALTER TABLE [Instructor].[Question] CHECK CONSTRAINT [Question_Course_Code_FK]
GO
ALTER TABLE [Instructor].[Question_Exam]  WITH CHECK ADD  CONSTRAINT [Question_Exam_Exam_id_FK] FOREIGN KEY([Exam_id])
REFERENCES [Instructor].[Exame] ([ID])
GO
ALTER TABLE [Instructor].[Question_Exam] CHECK CONSTRAINT [Question_Exam_Exam_id_FK]
GO
ALTER TABLE [Instructor].[Question_Exam]  WITH CHECK ADD  CONSTRAINT [Question_Exam_Question_id_FK] FOREIGN KEY([Question_id])
REFERENCES [Instructor].[Question] ([ID])
GO
ALTER TABLE [Instructor].[Question_Exam] CHECK CONSTRAINT [Question_Exam_Question_id_FK]
GO
ALTER TABLE [Instructor].[Student_Exame_in_Course]  WITH CHECK ADD  CONSTRAINT [Student_Exame_in_Course_Course_Code_FK] FOREIGN KEY([Course_code])
REFERENCES [Manager].[Course] ([Code])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Instructor].[Student_Exame_in_Course] CHECK CONSTRAINT [Student_Exame_in_Course_Course_Code_FK]
GO
ALTER TABLE [Instructor].[Student_Exame_in_Course]  WITH CHECK ADD  CONSTRAINT [Student_Exame_in_Course_Exam_id_FK] FOREIGN KEY([Exam_id])
REFERENCES [Instructor].[Exame] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Instructor].[Student_Exame_in_Course] CHECK CONSTRAINT [Student_Exame_in_Course_Exam_id_FK]
GO
ALTER TABLE [Instructor].[Student_Exame_in_Course]  WITH CHECK ADD  CONSTRAINT [Student_Exame_in_Course_student_SSN_FK] FOREIGN KEY([Student_SSN])
REFERENCES [Manager].[Student] ([SSN])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Instructor].[Student_Exame_in_Course] CHECK CONSTRAINT [Student_Exame_in_Course_student_SSN_FK]
GO
ALTER TABLE [Instructor].[Student_Exame_Question]  WITH CHECK ADD  CONSTRAINT [Student_Exame_Question_Exam_id_FK] FOREIGN KEY([Exam_id])
REFERENCES [Instructor].[Exame] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Instructor].[Student_Exame_Question] CHECK CONSTRAINT [Student_Exame_Question_Exam_id_FK]
GO
ALTER TABLE [Instructor].[Student_Exame_Question]  WITH CHECK ADD  CONSTRAINT [Student_Exame_Question_Quest_id_FK] FOREIGN KEY([Quest_id])
REFERENCES [Instructor].[Question] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Instructor].[Student_Exame_Question] CHECK CONSTRAINT [Student_Exame_Question_Quest_id_FK]
GO
ALTER TABLE [Instructor].[Student_Exame_Question]  WITH CHECK ADD  CONSTRAINT [Student_Exame_Question_student_SSN_FK] FOREIGN KEY([Student_SSN])
REFERENCES [Manager].[Student] ([SSN])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Instructor].[Student_Exame_Question] CHECK CONSTRAINT [Student_Exame_Question_student_SSN_FK]
GO
ALTER TABLE [Manager].[Branch]  WITH CHECK ADD  CONSTRAINT [Branch_Manager_FK] FOREIGN KEY([Manager_SSN])
REFERENCES [Manager].[Instructor] ([SSN])
GO
ALTER TABLE [Manager].[Branch] CHECK CONSTRAINT [Branch_Manager_FK]
GO
ALTER TABLE [Manager].[Class]  WITH CHECK ADD  CONSTRAINT [Class_Branch_ID_FK] FOREIGN KEY([Branch_ID])
REFERENCES [Manager].[Branch] ([ID])
ON UPDATE CASCADE
GO
ALTER TABLE [Manager].[Class] CHECK CONSTRAINT [Class_Branch_ID_FK]
GO
ALTER TABLE [Manager].[Class]  WITH CHECK ADD  CONSTRAINT [Class_IntakeNumber_FK] FOREIGN KEY([IntakeNumber])
REFERENCES [Manager].[Intake] ([Number])
ON UPDATE CASCADE
GO
ALTER TABLE [Manager].[Class] CHECK CONSTRAINT [Class_IntakeNumber_FK]
GO
ALTER TABLE [Manager].[Class]  WITH CHECK ADD  CONSTRAINT [Class_Track_ID_FK] FOREIGN KEY([Track_ID])
REFERENCES [Manager].[Track] ([ID])
ON UPDATE CASCADE
GO
ALTER TABLE [Manager].[Class] CHECK CONSTRAINT [Class_Track_ID_FK]
GO
ALTER TABLE [Manager].[CLS_CRS_INS]  WITH CHECK ADD  CONSTRAINT [CLS_CRS_INS_Class_ID_FK] FOREIGN KEY([Class_ID])
REFERENCES [Manager].[Class] ([ID])
ON UPDATE CASCADE
GO
ALTER TABLE [Manager].[CLS_CRS_INS] CHECK CONSTRAINT [CLS_CRS_INS_Class_ID_FK]
GO
ALTER TABLE [Manager].[CLS_CRS_INS]  WITH CHECK ADD  CONSTRAINT [CLS_CRS_INS_Course_Code_FK] FOREIGN KEY([Course_Code])
REFERENCES [Manager].[Course] ([Code])
ON UPDATE CASCADE
GO
ALTER TABLE [Manager].[CLS_CRS_INS] CHECK CONSTRAINT [CLS_CRS_INS_Course_Code_FK]
GO
ALTER TABLE [Manager].[CLS_CRS_INS]  WITH CHECK ADD  CONSTRAINT [CLS_CRS_INS_Instructor_SSN_FK] FOREIGN KEY([Instructor_SSN])
REFERENCES [Manager].[Instructor] ([SSN])
ON UPDATE CASCADE
GO
ALTER TABLE [Manager].[CLS_CRS_INS] CHECK CONSTRAINT [CLS_CRS_INS_Instructor_SSN_FK]
GO
ALTER TABLE [Manager].[Course_For_Student]  WITH CHECK ADD  CONSTRAINT [Course_For_Student_Course_Code_FK] FOREIGN KEY([Course_Code])
REFERENCES [Manager].[Course] ([Code])
GO
ALTER TABLE [Manager].[Course_For_Student] CHECK CONSTRAINT [Course_For_Student_Course_Code_FK]
GO
ALTER TABLE [Manager].[Course_For_Student]  WITH CHECK ADD  CONSTRAINT [Course_For_Student_student_SSN_FK] FOREIGN KEY([student_SSN])
REFERENCES [Manager].[Student] ([SSN])
GO
ALTER TABLE [Manager].[Course_For_Student] CHECK CONSTRAINT [Course_For_Student_student_SSN_FK]
GO
ALTER TABLE [Manager].[Department_Branch]  WITH CHECK ADD  CONSTRAINT [Department_Branch_Branch_id_FK] FOREIGN KEY([Branch_id])
REFERENCES [Manager].[Branch] ([ID])
GO
ALTER TABLE [Manager].[Department_Branch] CHECK CONSTRAINT [Department_Branch_Branch_id_FK]
GO
ALTER TABLE [Manager].[Department_Branch]  WITH CHECK ADD  CONSTRAINT [Department_Branch_Dept_id_FK] FOREIGN KEY([Dept_id])
REFERENCES [Manager].[Department] ([ID])
GO
ALTER TABLE [Manager].[Department_Branch] CHECK CONSTRAINT [Department_Branch_Dept_id_FK]
GO
ALTER TABLE [Manager].[Student]  WITH CHECK ADD  CONSTRAINT [Student_Class_ID_FK] FOREIGN KEY([Class_ID])
REFERENCES [Manager].[Class] ([ID])
GO
ALTER TABLE [Manager].[Student] CHECK CONSTRAINT [Student_Class_ID_FK]
GO
ALTER TABLE [Manager].[Track_Course]  WITH CHECK ADD  CONSTRAINT [Track_Course_Course_Code_FK] FOREIGN KEY([Course_Code])
REFERENCES [Manager].[Course] ([Code])
ON UPDATE CASCADE
GO
ALTER TABLE [Manager].[Track_Course] CHECK CONSTRAINT [Track_Course_Course_Code_FK]
GO
ALTER TABLE [Manager].[Track_Course]  WITH CHECK ADD  CONSTRAINT [Track_Course_Track_ID_FK] FOREIGN KEY([Track_ID])
REFERENCES [Manager].[Track] ([ID])
ON UPDATE CASCADE
GO
ALTER TABLE [Manager].[Track_Course] CHECK CONSTRAINT [Track_Course_Track_ID_FK]
GO
ALTER TABLE [Manager].[Works_on]  WITH CHECK ADD  CONSTRAINT [Works_on_Branch_id_FK] FOREIGN KEY([Branch_id])
REFERENCES [Manager].[Branch] ([ID])
GO
ALTER TABLE [Manager].[Works_on] CHECK CONSTRAINT [Works_on_Branch_id_FK]
GO
ALTER TABLE [Manager].[Works_on]  WITH CHECK ADD  CONSTRAINT [Works_on_Dept_id_FK] FOREIGN KEY([Dept_id])
REFERENCES [Manager].[Department] ([ID])
GO
ALTER TABLE [Manager].[Works_on] CHECK CONSTRAINT [Works_on_Dept_id_FK]
GO
ALTER TABLE [Manager].[Works_on]  WITH CHECK ADD  CONSTRAINT [Works_on_Inst_SSN_FK] FOREIGN KEY([Inst_SSN])
REFERENCES [Manager].[Instructor] ([SSN])
GO
ALTER TABLE [Manager].[Works_on] CHECK CONSTRAINT [Works_on_Inst_SSN_FK]
GO
ALTER TABLE [Instructor].[Exame]  WITH CHECK ADD  CONSTRAINT [Exame_Type_Check] CHECK  (([Type]='corrective' OR [Type]='exame'))
GO
ALTER TABLE [Instructor].[Exame] CHECK CONSTRAINT [Exame_Type_Check]
GO
ALTER TABLE [Manager].[Branch]  WITH CHECK ADD  CONSTRAINT [PhoneCheck] CHECK  ((len([Phone])=(11)))
GO
ALTER TABLE [Manager].[Branch] CHECK CONSTRAINT [PhoneCheck]
GO
ALTER TABLE [Manager].[Instructor]  WITH CHECK ADD  CONSTRAINT [genderCheck] CHECK  (([Gender]='F' OR [Gender]='M'))
GO
ALTER TABLE [Manager].[Instructor] CHECK CONSTRAINT [genderCheck]
GO
ALTER TABLE [Manager].[Student]  WITH CHECK ADD  CONSTRAINT [Student_gender_Check] CHECK  (([Gender]='F' OR [Gender]='M'))
GO
ALTER TABLE [Manager].[Student] CHECK CONSTRAINT [Student_gender_Check]
GO
/****** Object:  StoredProcedure [dbo].[SetQuestionToExam]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SetQuestionToExam](@InstrSSN char(14),@CourseCode varchar(40),
@ExamID varchar(20),@QuestID varchar(20),@ClassID int)
as
begin
 declare @Degree int;
 declare @QuestNUMInExam int;
   if dbo.checkExameWithCourse(@ExamID,@CourseCode,@InstrSSN)=1
   	 if dbo.CheckQuestWithCourse(@QuestID,@CourseCode) is not null
   	 begin
   	   set @Degree=dbo.CheckQuestWithCourse(@QuestID,@CourseCode)
	   set @QuestNUMInExam=NEXT VALUE FOR QuestNo_IN_Exam
   	   insert into [Instructor].[Question_Exam] values(@ExamID,@QuestID,@QuestNUMInExam,@Degree)
   	 end
   	 else print 'This Qestion is not allowed'
   else print 'Wrong Exame Or Course'
end
GO
/****** Object:  StoredProcedure [dbo].[ShowStudentCourse]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ShowStudentCourse](@StudentID char(14))
as
begin
	
	Select std.[Name] as StudentName,[Description] as CourseName,[Total_degree] as StudentDegree 
	FROM [Manager].[Student] as std 
	join [Manager].[Course_For_Student] as C_Std
	ON std.SSN=C_Std.student_SSN
	join [Manager].[Course] as Course
	ON Course.Code=C_Std.Course_Code
	Where std.SSN=@StudentID;
end
GO
/****** Object:  StoredProcedure [Instructor].[AddStudentToExam]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [Instructor].[AddStudentToExam](@INSTSSN char(14),@CourseCode varchar(40),
@studentSSN char(14),@ClassID int,@ExamID varchar(20)) -- [Instructor].[Student_Exame_in_Course]
as
begin
	declare @IsINstrTeachCours bit
	  if dbo.CheckInstWithCourse(@INSTSSN,@CourseCode,@ClassID)=1
	    if dbo.CheckStudentInCourse(@studentSSN,@CourseCode)=1
	    begin
	    insert into [Instructor].[Student_Exame_in_Course] values(@CourseCode,@studentSSN,@ExamID,null)
	    print 'Data Inserted'
		end
		else
		print 'This student is not register to this course'
	 else
	 print 'You have not permission to add this exame to this student'
end
GO
/****** Object:  StoredProcedure [Manager].[ADD_Class_Course_Instructor]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[ADD_Class_Course_Instructor](@ID int,@classID int,
@courseCode varchar(40),@instructorSSN varchar(14))
as 
begin

begin try
insert into [Manager].[CLS_CRS_INS] values (@ID,@classID,@courseCode,@instructorSSN);
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
---------------
GO
/****** Object:  StoredProcedure [Manager].[ADDBranch]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[ADDBranch](@ID varchar(20),@name varchar(200),@phone char(14),
@location varchar(200),@mangerSSN varchar(14))
as 
begin

begin try
insert into [Manager].[Branch] values (@ID,@name,@location,@phone,@mangerSSN);
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
GO
/****** Object:  StoredProcedure [Manager].[ADDClass]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [Manager].[ADDClass](@ID int,@name varchar(100),@intakeNum int,
@branchID varchar(20),@trackID varchar(20))
as 
begin

begin try
insert into [Manager].[Class] values (@ID,@name,@intakeNum,@branchID,@trackID);
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
GO
/****** Object:  StoredProcedure [Manager].[ADDCourse]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[ADDCourse](@Code varchar(40),@description char(200),@max int,@min int)
as 
begin

begin try
insert into [Manager].[Course] values (@Code,@description,@max,@min);
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end

---------------
GO
/****** Object:  StoredProcedure [Manager].[ADDIntake]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [Manager].[ADDIntake](@Number int,@Duration int,@startDate date,@EndDate date)
as 
begin
begin try
insert into [Manager].[Intake] values (@Number,@Duration,@startDate,@EndDate)
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
GO
/****** Object:  StoredProcedure [Manager].[ADDTrack]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[ADDTrack](@ID varchar(20),@name varchar(200),@description char(200))
as 
begin

begin try
insert into [Manager].[Track] values (@ID,@name,@description);
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end

---------------
GO
/****** Object:  StoredProcedure [Manager].[Delete_Class_Course_Instructor]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[Delete_Class_Course_Instructor](@ID int)
as 
begin
begin try
delete from [Manager].[CLS_CRS_INS] where ID=@ID;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
GO
/****** Object:  StoredProcedure [Manager].[DeleteBranch]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[DeleteBranch](@ID varchar(20))
as 
begin
begin try
delete from [Manager].[Branch]  where ID=@ID;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
GO
/****** Object:  StoredProcedure [Manager].[DeleteClass]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[DeleteClass](@ID int)
as 
begin
begin try
delete from [Manager].[Class] where ID=@ID;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
GO
/****** Object:  StoredProcedure [Manager].[DeleteCourse]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[DeleteCourse](@Code varchar(40))
as 
begin
begin try
delete from  [Manager].[Course] where Code=@Code;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
GO
/****** Object:  StoredProcedure [Manager].[DeleteIntake]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [Manager].[DeleteIntake](@IntkNO int)
as 
begin
begin try
delete from [Manager].[Intake]  where [Number]=@IntkNO;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
GO
/****** Object:  StoredProcedure [Manager].[DeleteTrack]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[DeleteTrack](@ID varchar(20))
as 
begin
begin try
delete from [Manager].[Track] where ID=@ID;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
GO
/****** Object:  StoredProcedure [Manager].[Update_Class_Course_Instructor]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [Manager].[Update_Class_Course_Instructor](@CLS_CRS_INS_ID int,@ID int=null,
@classID int=null,@courseCode varchar(40)=null,@instructorSSN varchar(14)=null)
as 
begin
begin try
if @ID is null
set @ID= @CLS_CRS_INS_ID;

if @classID is null
select @classID= [Class_ID] from [Manager].[CLS_CRS_INS] where ID=@CLS_CRS_INS_ID ;

if @courseCode is null
select @courseCode=[Course_Code]  from [Manager].[CLS_CRS_INS] where ID=@CLS_CRS_INS_ID ;

if @instructorSSN is null
select @instructorSSN= [Instructor_SSN] from [Manager].[CLS_CRS_INS] where ID=@CLS_CRS_INS_ID ;


update [Manager].[CLS_CRS_INS] set ID=@ID,[Class_ID]=@classID,[Course_Code]=@courseCode,
[Instructor_SSN]=@instructorSSN where ID=@CLS_CRS_INS_ID;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
 
------------------
GO
/****** Object:  StoredProcedure [Manager].[UpdateBranch]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[UpdateBranch](@BranchID varchar(20),@ID varchar(20)=null,
@name varchar(200)=null,@location varchar(200)=null,@phone char(14)=null,
@mangerSSN varchar(14)=null)
as 
begin
begin try
if @ID is null
select @ID= ID from [Manager].[Branch] where ID= @BranchID;

if @name is null
select @name= Name from [Manager].[Branch] where ID= @BranchID;

if @location is null
select @location= Location from [Manager].[Branch] where ID= @BranchID;

if @phone is null
select @phone= Phone from [Manager].[Branch] where ID= @BranchID;

if @mangerSSN is null
select @mangerSSN= [Manager_SSN] from [Manager].[Branch] where ID= @BranchID;

update [Manager].[Branch] set ID=@ID,[Name]=@name,[Location]=@location,
[Phone]=@phone,[Manager_SSN]=@mangerSSN where ID=@BranchID;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
GO
/****** Object:  StoredProcedure [Manager].[UpdateClass]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[UpdateClass](@ClassID int,@ID int=null,@name varchar(100)=null,
@intakeNum int=null,@branchID varchar(20)=null,@trackID varchar(20)=null)
as 
begin
begin try
if @ID is null
set @ID= @ClassID;

if @name is null
select @name= Name from [Manager].[Class] where ID= @ClassID;

if @intakeNum is null
select @intakeNum=[IntakeNumber]  from [Manager].[Class] where ID= @ClassID;

if @branchID is null
select @branchID=[Branch_ID]  from [Manager].[Class] where ID= @ClassID;

if @trackID is null
select @trackID= [Track_ID] from [Manager].[Class] where ID= @ClassID;

update [Manager].[Class] set ID=@ID,[Name]=@name,[IntakeNumber]=@intakeNum,
[Branch_ID]=@branchID,[Track_ID]=@trackID where ID=@ClassID;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
 
------------------
GO
/****** Object:  StoredProcedure [Manager].[UpdateCourse]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [Manager].[UpdateCourse](@CourseCode varchar(40),@Code varchar(40)=null,
@description char(200)=null,@max int=null,@min int=null)
as 
begin
begin try
if @Code is null
set @Code= @CourseCode;

if @description is null
select @description=[Description]  from [Manager].[Track] where @Code= @CourseCode;

if @max is null
select @max= [Max_degree] from [Manager].[Course] where @Code= @CourseCode;

if @min is null
select @min= [Min_degree] from [Manager].[Course] where @Code= @CourseCode;

update [Manager].[Course] set [Code]=@Code,[Description]=@description,
[Max_degree]=@max,[Min_degree]=@min where Code=@CourseCode;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
 
------------------
GO
/****** Object:  StoredProcedure [Manager].[UpdateIntake]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [Manager].[UpdateIntake](@IntkNO int ,@Number int=null,
@startDate date=null,@EndDate date=null)
as 
begin
begin try
if @Number is null
select @Number= Number from [Manager].[Intake] where Number= @IntkNO;

if @startDate is null
select @startDate=[Start_date] from [Manager].[Intake] where Number= @IntkNO;

if @EndDate is null
select @EndDate=[End_date] from [Manager].[Intake] where Number =@IntkNO;

update [Manager].[Intake] set [Number]=@Number,[Start_date]=@startDate,
[End_date]=@EndDate where [Number]=@IntkNO;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
GO
/****** Object:  StoredProcedure [Manager].[UpdateTrack]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [Manager].[UpdateTrack](@TrackID varchar(20),@ID varchar(20)=null,
@name varchar(200)=null,@description char(200)=null)
as 
begin
begin try
if @ID is null
set @ID= @TrackID;

if @name is null
select @name= Name from [Manager].[Track] where ID= @TrackID;

if @description is null
select @description=[Description]  from [Manager].[Track] where ID= @TrackID;


update [Manager].[Track] set ID=@ID,[Name]=@name,[Description]=@description
 where ID=@TrackID;
print 'Done Successfuly'
end try
begin catch
print 'Error'
end catch
end
 
------------------
GO
/****** Object:  StoredProcedure [student].[startExam]    Script Date: 1/29/2022 11:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [student].[startExam](@studentSSN char(14),@courseName varchar(100))
as
begin
   Declare @Course_code varchar(40)
   declare @Exam_id varchar(20)
   set @Course_code=dbo.GetCourseCode(@courseName)
   set @Exam_id=dbo.GetExameID(@studentSSN,@Course_code)
   --select * from dbo.selectQuestAnswers(@Exam_id)
  select QS.[Question_no_IN_Exame],Q.text[Text],Ans.[Text] from 
   [Instructor].[Question_Exam] as QS join [Instructor].[Question] as Q
   on QS.[Question_id]=Q.ID join
  [Instructor].[Answer] as Ans on Q.ID=Ans.[Qestion_id]
  where QS.[Exam_id]=@Exam_id
 end
GO
USE [master]
GO
ALTER DATABASE [ExaminationSystem] SET  READ_WRITE 
GO
