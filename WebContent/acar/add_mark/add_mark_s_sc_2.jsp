<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.add_mark.*" %>
<jsp:useBean id="am_db" scope="page" class="acar.add_mark.AddMarkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
	function AncReg(){
		var SUBWIN="./add_mark_i.jsp";	
		window.open(SUBWIN, "AncReg", "left=100, top=100, width=520, height=350, scrollbars=no");
	}

	function AncDisp(bbs_id){
		var SUBWIN="./add_mark_c.jsp?bbs_id=" + bbs_id;	
		window.open(SUBWIN, "AncDisp", "left=100, top=100, width=520, height=350, scrollbars=no");
	}
	
	function Update(seq, br_id, dept_id, mng_st, mng_way, marks, start_dt, end_dt, use_yn){
		var fm = document.form1;
//		fm.add_br_id.vlaue;
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String s_start_dt = request.getParameter("s_start_dt")==null?"":request.getParameter("s_start_dt");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();	
	
	CodeBean[] depts = c_db.getCodeAll2("0002"); /* 코드 구분:부서명 */	
	int dept_size = depts.length;
	
	CodeBean[] ways = c_db.getCodeAll2("0005"); /* 코드 구분:대여방식 */	
	int way_size = ways.length;	
	
	Vector adds = am_db.getAddMarkList(s_br_id, s_dept_id, s_start_dt);
	int add_size = adds.size();	
%>
<form action="./register_frame.jsp" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="s_br_id" value="<%=s_br_id%>">
<input type="hidden" name="s_dept" value="<%=s_dept_id%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="brch_size" value="<%=brch_size%>">
<input type="hidden" name="dept_size" value="<%=dept_size%>">
<input type="hidden" name="way_size" value="<%=way_size%>">
<table border=0 cellspacing=0 cellpadding=0 width=800>
	<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	<%	}%>
    <tr>
        <td class=line>
            
        <table border=0 cellspacing=1 width=100%>
          <tr> 
            <td class='title' width='140' rowspan="2">영업소명</td>
            <td class='title' width='100' rowspan="2"> 부서명</td>
            <td class='title' rowspan="2" width="100"> 관리구분</td>
            <td class='title' rowspan="2" width="100">관리방식</td>
            <td class='title' rowspan="2" width="100"> 점수</td>
            <td class='title' width='200' rowspan="2">적용일자</td>
            <td class='title' width='60' rowspan="2">처리</td>
          </tr>
          <tr> 
          <%for (int i = 0 ; i < add_size ; i++){
				Hashtable add = (Hashtable)adds.elementAt(i);%>
          <tr> 
            <td align="center"><a href="javascript:Update('<%=add.get("SEQ")%>','<%=add.get("BR_ID")%>','<%=add.get("DEPT_ID")%>','<%=add.get("MNG_ST")%>','<%=add.get("MNG_WAY")%>','<%=add.get("MARKS")%>','<%=add.get("START_DT")%>','<%=add.get("END_DT")%>','<%=add.get("USE_YN")%>')" onMouseOver="window.status=''; return true"> 
              <%=add.get("BR_NM")%></a></td>
            <td align="center"><%=add.get("DEPT_NM")%></td>
            <td align="center"><%=add.get("MNG_WAY_NM")%></td>
            <td align="center"><%=add.get("MNG_ST_NM")%></td>
            <td align="center"><%=add.get("MARKS")%>점</td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(add.get("START_DT")))%> ~ 현재</td>
            <td align="center">&nbsp;</td>
          </tr>
		  <%}%>
          <tr> 
            <td align="center">
              <select name='add_br_id' onChange='javascript:search();'>
                <%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
                <option value='<%= branch.get("BR_ID") %>'  <%if(br_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
                <%= branch.get("BR_NM")%> </option>
                <%							}
						}		%>
              </select>
            </td>
            <td align="center"> 
              <select name='add_dept_id' onChange='javascript:search();'>
                <option value=''>전체</option>
                <%if(dept_size > 0){
					for(int i = 0 ; i < dept_size ; i++){
						CodeBean dept = depts[i];%>
                <option value='<%= dept.getCode()%>'> 
                <%= dept.getNm()%> </option>
                <%	}
				}%>
              </select>
            </td>
            <td align="center"> 
              <select name='add_mng_st' onChange='javascript:search();'>
                <option value='0'>업체</option>
                <%if(way_size > 0){
					for(int i = 0 ; i < way_size ; i++){
						CodeBean way = ways[i];%>
                <option value='<%= way.getNm_cd()%>'> 
                <%= way.getNm()%> </option>
                <%	}
				}%>
              </select>
            </td>
            <td align="center"> 
              <select name='add_mng_way' onChange='javascript:search();'>
                <option value='1'>단독</option>
                <option value='2'>공동</option>
              </select>
            </td>
            <td align="center"> 
              <input type="text" name="add_marks" size="4" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="add_start_dt" size="8" class="text">
              ~ 
              <input type="text" name="add_end_dt" size="8" class="whitetext">
            </td>
            <td align="center"><a href="#">등록</a>&nbsp;<a href="#">수정</a></td>
          </tr>
        </table>
        </td>
    </tr>
	<!--<tr>
	  <td>* 부서명||전체 : 가산점이 적용되는 모든 부서</td>
	</tr>-->
</table>
</form>
</body>
</html>