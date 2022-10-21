<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.user_mng.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")		==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String chk[] 	= request.getParameterValues("chk");	

	int sh_height = request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String gi_no = "";
	String firm_nm = "";
	String client_nm = "";
	String ssn = "";
	String enp_no = "";
	String gi_amt = "";
	
	String gi_start_dt = "";
	String gi_end_dt = "";
	String rent_start_dt = "";
	String rent_end_dt = "";

	String user_nm = "";
	String hot_tel = "";
	String dept_nm = "";
	
%>


<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<style>
/* @font-face { font-family: 'oACYCZno'; src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_eight@1.0/oACYCZno.woff') format('woff'); font-weight: normal; font-style: normal; } */
@import url('https://cdn.rawgit.com/moonspam/NanumSquare/master/nanumsquare.css');
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    background-color: #ddd;
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    padding-top: 10mm; /* set contents area */
    padding-left: 10mm; /* set contents area */
    padding-right: 10mm; /* set contents area */
     margin-top: 10mm;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 0px;
   /*  border: 1px #888 solid ; */
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
       
        background: #fff;
    }
    .paper {
        margin: 0;
        border: initial;
        border-radius: initial;
        width: initial;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
   
}
	/* #contents {font-size:9pt}; */
 table {
     border: 0.5px solid #444444;
    border-collapse: collapse; 
  }
  th, td {
    border: 0.5px solid #444444;
    font-size:11pt;
    text-align:center;
  }
  td{
  
  }
  input[type="text"]{font-family: 'NanumSquare', sans-serif;border:0px;margin:0px;padding:0px;width:200px;}
.title{font-size:11.5pt;font-weight:bold;}  
.contents {font-size:11.5pt; /* font-family:돋움; */ }
.contents tr{ height:30px;}
/* #wrap { font-family: 'oACYCZno', sans-serif;} */
#wrap { font-family: 'NanumSquare', sans-serif;}

 #hrTable{
 	background-color:black; 
}	
#hrTable td{
	 border-style:solid; 
	border-left-width:2px;
	border-color:white;
}

</style>
</head>
<body leftmargin="" topmargin="1" >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
	<script>
	</script>
	
<%
	
	for(int i = 0 ; i < chk.length ; i++){
		s_kd = "2";
		t_wd = chk[i];
		
		Vector vt = a_db.getGuaInsureList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5);
		int vt_size = vt.size();
	
		for(int j = 0 ; j < 1 ; j++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(j);
			gi_no = String.valueOf(ht.get("GI_NO"));
			firm_nm = String.valueOf(ht.get("FIRM_NM"));
			client_nm = String.valueOf(ht.get("CLIENT_NM"));
			ssn = String.valueOf(ht.get("SSN"));
			enp_no = String.valueOf(ht.get("ENP_NO"));
			gi_amt = String.valueOf(ht.get("GI_AMT"));
		
			gi_start_dt = String.valueOf(ht.get("GI_START_DT"));
			gi_end_dt = String.valueOf(ht.get("GI_END_DT"));
			rent_start_dt = String.valueOf(ht.get("RENT_START_DT"));
			rent_end_dt = String.valueOf(ht.get("RENT_END_DT"));
		}
		
		UsersBean mng_user 	= umd.getUsersBean(ck_acar_id);
		user_nm = mng_user.getUser_nm();
		hot_tel = mng_user.getHot_tel();
		dept_nm = mng_user.getDept_nm(); 

%>
    <div class="paper">
    <div class="content">
		<div id="wrap" style="width:100%;">
			<div>
				<div style="margin-top:50px;margin-bottom:8px;font-size:9pt">(10─02─005, 2017.07.24)</div>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' align="center" class="contents">
					<tr style="margin:10px;">
						<td width=82%" style="text-align:left;margin-bottom:15px;padding:7px 5px;font-size:18pt;font-weight:bold">&nbsp;&nbsp;이행완료(보증채무소멸)&nbsp;&nbsp;확인서</td>
						<td width="18%"><img src=/acar/images/center/gur_ins_logo.jpg width=120></td>
						
					</tr>
				</table>
			
			
			</div>
			<br>
			<div style="margin-top:4px;">
				<div style="margin-bottom:10px;font-weight:bold;font-size:12pt">&nbsp;<span>□</span>&nbsp;&nbsp;보증보험계약&nbsp;&nbsp;및&nbsp;&nbsp;주계약내용&nbsp;</div> 
				<table border="0" cellspacing="0" cellpadding='0' width='100%' align="center" class="contents" style="table-layout:;">
					<tr>
						<td class="title" style="padding:8.5px 0px;"><span style="letter-spacing:35px;">증권번</span>호</td>
						<td colspan="3" style="text-align:left;">&nbsp;&nbsp;<input type="text" style="font-size:11pt;" value=<%=gi_no %>></td>		
					</tr>
					<tr>
						<td class="title"style="padding:8.5px 0px"><span style="letter-spacing:35px;">보험상</span>품</td>
						<td colspan="3" style="text-align:left;">&nbsp;&nbsp;<input type="text" style="font-size:11pt;" value="이행(지급)보증보험"></td>
					</tr>
					<tr>
						<td class="title" style="padding:8.5px 0px" width="25%"><span style="letter-spacing:22px;">보험계약</span>자</td>
						<%if(firm_nm.equals(client_nm)){ %>
						<td width="25%" style="text-align:left;">&nbsp;&nbsp;<%=firm_nm %></td>		
						<td class="title" width="18%"><span style="letter-spacing:2px;">법인(사업자</span>)<br>
							<span style="letter-spacing:17px;">등록번</span>호</td>		
						<td style="text-align:left;">&nbsp;&nbsp;<%=ssn %></td>		
						<%}else{ %>
						<td width="25%" style="text-align:left;">&nbsp;&nbsp;<%=firm_nm %><br>&nbsp;&nbsp;<%=client_nm %></td>		
						<td class="title" width="18%"><span style="letter-spacing:5px;">법인(사업자</span>)<br>
							<span style="letter-spacing:18px;">등록번</span>호</td>		
						<td style="text-align:left;">&nbsp;&nbsp;<input type="text" style=" font-size:11pt;" value=<%=enp_no %>><br>&nbsp;&nbsp;<input type="text" style=" font-size:11pt;" value=<%=ssn %>></td>		
						<%} %>
					</tr>
					<tr style="">	
						<td class="title" style="padding:8.5px 0px "><span style="letter-spacing:15px;">보험가입금</span>액</td>
						<td style="text-align:left;">&nbsp;&nbsp;<%=Util.parseDecimal(gi_amt)%>&nbsp;원&nbsp;</td>
						
						<td class="title" width="18%"><span style="letter-spacing:17px;">보험기</span>간</td>		
						<td style="text-align:left;">&nbsp;&nbsp;<input type="text" style="font-size:11pt;width:80px;" value=<%=AddUtil.ChangeDate(gi_start_dt,"YYYY-MM-DD")%>>~
						&nbsp;&nbsp;<input type="text" style="font-size:11pt;width:80px;" value=<%=AddUtil.ChangeDate(gi_end_dt,"YYYY-MM-DD")%>></td>
						
					</tr>
				</table>
			</div>			
			<div style="margin-top:0px;">
				<table border="0" cellspacing="0" cellpadding='0' width='100%' align="center" class="contents" style="table-layout:;">
					<tr>
						<td class="title" style="padding:8.5px 0px"><span style="letter-spacing:35px;">주계약</span>명</td>
						<td colspan="3" style="text-align:left;">&nbsp;&nbsp;<input type="text" style="font-size:11pt;" value="자동차대여이용계약"></td>		
					</tr>
					<tr>
						<td class="title"  width="25%" style="padding:8.5px 0px"><span style="letter-spacing:35px;">계약금</span>액</td>
						<td style="text-align:left;" width="25%">&nbsp;&nbsp;<%=Util.parseDecimal(gi_amt)%>&nbsp;원&nbsp;</td>		
						<td class="title" width="18%"><span style="letter-spacing:17px;">계약기</span>간</td>		
						<td style="text-align:left;">&nbsp;&nbsp;<input type="text" style="font-size:11pt;width:80px;" value=<%=AddUtil.ChangeDate(rent_start_dt,"YYYY-MM-DD")%>>~
						&nbsp;&nbsp;<input type="text" style="font-size:11pt;width:80px;" value=<%=AddUtil.ChangeDate(rent_end_dt,"YYYY-MM-DD")%>></td>
					</tr>
				</table>
			</div>			
			<br>
			<div style="margin-top:3px;">
				<div style="margin-bottom:9px;font-weight:bold;font-size:12pt;">
					&nbsp;<span>□</span>&nbsp;&nbsp;확인사항&nbsp;
					<span style="font-size:9.5pt;font-weight:normal;word-spacing:2px;">
						&nbsp;&nbsp;&nbsp;※<span style="text-decoration: underline;font-weight:bold">해당하는 사유에 체크(<img src=/acar/images/center/check_icon.png width="10" height="9">)</span>하시고, "주계악상 채무이행완료일" 또는  "보증채무소멸일"을 기재하여 주십시오.
					</span>
				</div> 
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed;">
					<tr style="border-bottom:2px dotted darkgray;">
						<td>
							<div style="font-size:11pt;margin:17 5px;text-align:left;word-spacing:3px;">
								<div style="margin-bottom:3px;">&nbsp; 피보험자 본인은 상기 보증보험계약과 관련하여, 아래와 같은 사유가 발생함으로써, <b>"보증보험계약의 효력"과</b></div>
								<div><b>&nbsp;"서울보증보험(주)의 보증채무 내지 보장책임"이 (</b><span> <input type="text" style="font-size:10.5pt;width:100px;" value=<%=AddUtil.ChangeDate(rent_end_dt,"YYYY-MM-DD")%>></span> )<b>자로 완전히 소멸하였음을 확인</b>합니다.</div>
							</div>
						</td>
					</tr>
					<tr>
						<td class="">
							<div style="font-size:11pt;margin:22 8px;text-align:left;word-spacing:3px;">
								<div style="margin-bottom:8px;">&nbsp;<b>ㆍ<input type="checkbox" checked>보험계약자가 주계약상 채무를 완전히 이행하였음</b></div>
								<div style="margin-bottom:3px;">&nbsp;<b>ㆍ 보험계약자가 주계약상 채무를 완전히 이행하지는 않았으나, 아래와 같은 사유가 발생하였음</b></div>
								<div style="margin-left:37px;"><input type="checkbox">보증보험증권을 다른 담보(타기관 보증서, 부동산 담보 등)로 대체함</div>
								<div style="margin-left:37px;"><input type="checkbox">담보를 받지 않고, 신용거래로 전환함<span style="margin-right:26px;"></span> <input type="checkbox">기타사유 :</div>
							</div>
						
						</td>
					</tr>
				</table>
			</div>			
			<br>
			<div style="margin-bottom:0px;height:28px;">
				<div style="height:30px;width:200px;float:left;font-weight:bold;font-size:12pt;padding-top:5px;">
					&nbsp;<span>□</span>&nbsp;&nbsp;확인자(피보험자)&nbsp;
				</div>
				<div style="height:30px;width:200px;border:0.5px solid black;border-radius:3px;float:right;font-size:9pt;padding-top:9px;padding-right:4px;text-align:right;">
					<span style="letter-spacing:15px;"><input type="text" style="width:45px;text-align:right;margin-right:5px;">년<input type="text" style="width:25px;text-align:right;margin-right:5px;">월</span>
					<input type="text" style="width:25px;text-align:right;margin-right:5px;">일
				</div>
			</div>
			<div style="margin-top:3px;">
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents">
					<tr>
						<td class="title" width="17%" style="padding:10px 0px"><span style="letter-spacing:5px;">상호/대표</span>자</td>
						<td style="text-align:left;font-size:14pt;">
							<span style="margin-right:45px;">&nbsp;(주)아마존카</span>	
							<span style="word-spacing:22px;">대표이사 조성희 <span style="font-size:9pt;">(인)</span></span>
						</td>		
					</tr>
					<tr>
						<td class="title" style="padding:10px 0px"><span style="letter-spacing:70px;">주</span>소</td>
						<td style="text-align:left;font-size:14pt;">&nbsp;<span>서울특별시 영등포구 의사당대로 8 802호</span>
						</td>
					</tr>
				</table>
			</div>			
				<div style="margin-top:0px;">
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents">
					<tr>
						<td class="title" width="17%" style="padding:10px 0px"><span style="letter-spacing:29px;">담당</span>자</td>
						<td class="title"width="30%"  style="text-align:left;">&nbsp;&nbsp;<span style="letter-spacing:10px;"><%=user_nm %></span></td>		
						<td class="title" width="17%"><span style="letter-spacing:70px;">직</span>위	
						<td width="%"></td>		
					</tr>
					<tr>
						<td class="title" style="padding:10px 0px"><span style="letter-spacing:15px;">담당부</span>서</td>
						<td class="title"width="30%"  style="text-align:left;">&nbsp;&nbsp;<span style="letter-spacing:10px;"><%=dept_nm %></span></td>
						<td class="title"><span style="letter-spacing:27px;">연락</span>처</td>	
						<td class="title"width=""  style="text-align:left;">&nbsp;&nbsp;<span style=""><%=hot_tel %></span></td>
					</tr>
				</table>
			</div>			
			<br>
			<div style="margin-top:0px;">
				<div style="margin-bottom:10px;font-weight:bold;font-size:12pt;">&nbsp;서울보증보험 주식회사 귀중&nbsp;</div> 
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed;">
					<tr>
						<td class="">
							<div style="font-size:8.5pt;margin:7 7px;text-align:left;">
								<div style="margin-bottom:3px;">※보험계약자님께 알려드립니다.</div>
								<div style="margin-bottom:3px;">주계약상의 채무(의무)를 보험기간 중에 완전히 이행하였음 등을 피보험자로부터 동 확인서에 확인받는 경우에는 보험약관에 따라 환급받으실 보험료가</div>
								<div style="margin-bottom:3px;">있을 수 있습니다. '환급가능한 보험료가 있는지 여보' 및 '환급절차' 등에 대해서는 동 확인서를 영업지점에 제출하실 때 안내받으시기 바랍니다.</div>
							</div>
						</td>
					</tr>
				</table>
			</div>			
			<br>
		
			<div style="margin-top:3px;">
				<table id="hrTable" border="0" cellspacing="0" cellpadding='0' width='98%' style="height:3px;">
					<tr>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
					</tr>
				</table>
			</div>
			<div style="margin-top:14px;"align="right">
				<table border="0" cellspacing="0" cellpadding='0' width='76%' height='76' class="contents" style="table-layout:fixed;">
					<tr>
						<td width="6%" style="font-size:9pt;">
							<div>회<br>사<br>기<br>재<br>란</div>
						</td>
						<td>
							<div style="font-size:9pt; position: relative;top:-24; text-align:left;color:lightgray;font-style:italic">
								<span>&nbsp;확인일시 등 기재</span>
							</div>
						</td>
					</tr>
				</table>
			</div>	
			<br>
	</div>
	</div>
	</div>
	<%} %>
</form>
</body>
</head>
</html>