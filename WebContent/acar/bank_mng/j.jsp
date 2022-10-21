<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
		//대출신청리스트
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
    long t_amt4[] = new long[1];
    long t_amt5[] = new long[1];
    long t_amt6[] = new long[1];
    long t_amt7[] = new long[1];
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<script language='JavaScript' src='/include/common.js'></script>
<title>무제 문서</title>
<style type=text/css>
<!--
.style1 {
    font-family: dotum;
	font-size: 20pt;
	font-weight: bold;
}

.style2 {
    font-family: dotum;
	font-size: 12px;
}

.style3 {
    font-family: dotum;
	font-size: 14px;
	text-decoration: underline;
	font-weight: bold;
}
.style4 {
    font-family: dotum;
	font-size: 14px;
	font-weight: bold;
}
.style5 {
    font-family: dotum;
	font-size: 12px;
	font-weight: bold;
}
-->


</style>
</head>
<!-- MeadCo ScriptX -->

<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab" >
</object>

<body leftmargin=0 rightmargin=0 bottommargin=0 topmargin=0>
<% if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					Hashtable ht = (Hashtable)FineList.elementAt(i);	
%>

<table width=698 border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td height=20></td>
    </tr>
        <td>
            <table width=698 border=0 cellpadding=49 cellspacing=1 bgcolor=#000000>
                <tr>
                    <td bgcolor=#FFFFFF>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=12></td>
                            </tr>
                            <tr>
                                <td height=50 align=center><span class=style1>대여료 청구권 양도통지 위임장</span></td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td><table width=100%  border=0 cellspacing=0 cellpadding=0>
                                    <tr>
                                        <td width=45% height=30 ><span class=style3><%=ht.get("FIRM_NM")%>&nbsp;귀하 </span></td>
                                        <td align=right>&nbsp;</td>
                                        <td width=45% align=right><span class=style4>&nbsp&nbsp;&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp;&nbsp;월&nbsp;&nbsp;&nbsp;일</span></td>
                                    </tr>
                                </table></td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td><span class=style2>* <span class=style5>대여료 청구권 양도인</span> : &nbsp;&nbsp;서울특별시 영등포구 여의도동 까뮤이앤씨빌딩 8층 (주)아마존카</span></td>
                            </tr>
                            <tr>
                                <td height=40></td>
                            </tr>
                            <tr>
                                <td><span class=style2>* <span class=style5>대여료 청구권 양수인</span> : &nbsp;&nbsp;서울특별시 중구 을지로6가 18-12 주식회사 두산캐피탈</span></td>
                            </tr>
                            <tr>
                                <td height=70></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>위 대여료 청구권 양도인은 &nbsp;<font color=FFFFFF>0000</font>년 &nbsp;<font color=FFFFFF>00</font>월 &nbsp;<font color=FFFFFF>00</font>일 대여료 청구권 양수인에게 대여료 청구권 양도인이 귀사(하)에 </span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>대하여 가지는 다음 1.항의 대여료 청구권을 전액 양도하였는바, 양도한 대여료 청구권의 채무자에 대한 대여료</span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>청구권 양도통지를 대여료 청구권 양수인에게 위임함으로써, &nbsp;대여료 청구권 양수인이 대여료 청구권 양도인을 </span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>대리하여 적법하게 채무자에 대한 대여료 청구권 양도통지를 할 수 있는 권한을 수여합니다.</span></td>
                            </tr>
                            <tr>
                                <td height=100></td>
                            </tr>
                            <tr>
                                <td align=center><span class=style2>---------- 다&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;음 ----------</span></td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td><span class=style5>[양도 대여료 청구권의 표시]</span></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>대여료 청구권 양도인이 귀사(하)와 <font color=FFFFFF>0000</font>년 <font color=FFFFFF>00</font>월 <font color=FFFFFF>00</font>일 체결한 아래의 대여계약에 따라 대여료 청구권 양도인이</span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>&nbsp;<font color=FFFFFF>0000</font>년 &nbsp;<font color=FFFFFF>00</font>월 &nbsp;<font color=FFFFFF>00</font>일 현재 귀사(하)에 대하여 가지고 있거나 장래 가지게 될 일체의 대여료 청구권.</span></td>
                            </tr>
                            <tr>
                                <td height=100></td>
                            </tr>
                            <tr>
                                <td align=center><span class=style2>---------- 아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;래 ----------</span></td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td><span class=style2>* <span class=style5>대여계약번호</span> : <span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> 
                                및 이에 부수하여 체결한 일체의 계약</span></td>
                            </tr>
                     
                            <tr>
                                <td height=22></td>
                            </tr>
                       
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
       <%  if ( i == FineList.size()-1 ) {%>
             <% } else { %>
    <tR>
        <td height=10></td>
    </tr>
      <% } %>   
</table>
 <% 	} %>
  <% 	} %>
</body>

 
</html>

<script>
onprint();

function onprint(){
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 10.0; //좌측여백   
factory.printing.topMargin = 10.0; //상단여백    
factory.printing.rightMargin = 10.0; //우측여백
factory.printing.bottomMargin = 10.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>
