<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.common.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
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
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");	
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	AncBean a_r [] = oad.getAncAll(gubun, gubun_nm, acar_id);
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();	
%>
<form action="./register_frame.jsp" name="AncRegForm" method="POST">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<table border=0 cellspacing=0 cellpadding=0 width=800>
	<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	<%	}%>
    <tr>
        <td class=line>
            
        <table border=0 cellspacing=1 width=100%>
          <tr> 
            <td class='title' width='110' rowspan="2">영업소명</td>
            <td class='title' width='80' rowspan="2"> 부서명</td>
            <td class='title' colspan="2"> 업체</td>
            <td class='title' colspan="2"> 일반식</td>
            <td class='title' colspan="2"> 맞춤식</td>
            <td class='title' colspan="2"> 기본식</td>
            <td class='title' width='150' rowspan="2">적용일자</td>
            <td class='title' width='60' rowspan="2">처리</td>
          </tr>
          <tr> 
            <td class='title' width='50' height="23">단독</td>
            <td class='title' width='50' height="23">공동</td>
            <td class='title' width='50' height="23">단독</td>
            <td class='title' width='50' height="23">공동</td>
            <td class='title' width='50' height="23">단독</td>
            <td class='title' width='50' height="23">공동</td>
            <td class='title' width='50' height="23">단독</td>
            <td class='title' width='50' height="23">공동</td>
          </tr>
          <%	if(a_r.length > 0){
	    for(int i=0; i<a_r.length; i++){
    	    a_bean = a_r[i];
			String r_ch = a_bean.getRead_chk();
%>
          <tr> 
            <td align="center"><a href="javascript:AncDisp('<%=a_bean.getBbs_id()%>')" onMouseOver="window.status=''; return true"> 
              <%if(r_ch.equals("1")){%>
              <font color="#666666"><%=a_bean.getTitle()%></font> 
              <%}else{%>
              <%=a_bean.getTitle()%> 
              <%}%>
              </a></td>
            <td align="center"><%=a_bean.getUser_nm()%></td>
            <td align="center"> 
              <input type="text" name="textfield2" size="2" class="num">
              점</td>
            <td align="center"> 
              <input type="text" name="textfield" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield3" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield4" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield5" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield6" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield7" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield8" size="2" class="num">
              점 </td>
            <td align="center">
              <input type="text" name="textfield82" size="8" class="text">
              ~
              <input type="text" name="textfield84" size="8" class="text">
            </td>
            <td align="center"><a href="#">수정</a></td>
          </tr>
          <%		}
 	}%>
          <tr> 
            <td align="center"><a href="javascript:AncDisp('<%=a_bean.getBbs_id()%>')" onMouseOver="window.status=''; return true"> 
              </a>
              <select name='brch_id' onChange='javascript:search();'>
                <%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
                <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
                <%= branch.get("BR_NM")%> </option>
                <%							}
						}		%>
              </select>
            </td>
            <td align="center">
              <select name='select' onChange='javascript:search();'>
                <option value=''>영업팀</option>
                <option value=''>관리팀</option>				
              </select>
            </td>
            <td align="center"> 
              <input type="text" name="textfield2" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield3" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield4" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield5" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield6" size="2" class="num">
              점 </td>
            <td align="center"> 
              <input type="text" name="textfield7" size="2" class="num">
              점</td>
            <td align="center"> 
              <input type="text" name="textfield8" size="2" class="num">
              점 </td>
            <td align="center">
              <input type="text" name="textfield83" size="8" class="text">
              ~ 
              <input type="text" name="textfield85" size="8" class="text">
            </td>
            <td align="center"><a href="#">등록</a></td>
          </tr>
        </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>