<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.add_mark.*" %>
<jsp:useBean id="am_db" scope="page" class="acar.add_mark.AddMarkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//수정하기
	function update(idx){
		var fm = document.form1;	
		if(fm.add_size.value == 1){	
			if(fm.u_marks.value == ''){ alert("가산점수를 확인하십시오."); fm.u_marks.focus(); return; }
			fm.seq.value = fm.u_seq.value;				
			fm.marks.value = fm.u_marks.value;				
			fm.end_dt.value = fm.u_end_dt.value;										
		}else{
			if(fm.u_marks[idx].value == ''){ alert("가산점수를 확인하십시오."); fm.u_marks[idx].focus(); return; }
			fm.seq.value = fm.u_seq[idx].value;				
			fm.marks.value = fm.u_marks[idx].value;				
			fm.end_dt.value = fm.u_end_dt[idx].value;				
		}
		if(!confirm('수정하시겠습니까?'))	return;
		fm.cmd.value = 'u';
		fm.target='i_no';
		fm.submit();		
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
	String s_gubun = request.getParameter("s_gubun")==null?"":request.getParameter("s_gubun");
	String s_mng_who = request.getParameter("s_mng_who")==null?"":request.getParameter("s_mng_who");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
	
	
	CodeBean[] ways = c_db.getCodeAll2("0005", "Y"); /* 코드 구분:대여방식-가산점적용 */
	int way_size = ways.length;	

	CodeBean[] stats = c_db.getCodeAll2("0006", "Y"); /* 코드 구분:가산관리현황-가산점적용 */
	int stat_size = stats.length;	
		
	CodeBean[] way2s = c_db.getCodeAll2("0005", ""); /* 코드 구분:대여방식 */
	int way_size2 = way2s.length;
	
	Vector adds = am_db.getAddMarkList2(s_br_id, s_dept_id, s_gubun, s_mng_who);
	int add_size = adds.size();	
%>
<form action="./add_mark_null_ui.jsp" name="form1" method="POST">
<input type="hidden" name="cmd" value="u">
<input type="hidden" name="seq" value="">
<input type="hidden" name="marks" value="">
<input type="hidden" name="end_dt" value="">
<input type="hidden" name="add_size" value="<%=add_size%>">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="s_br_id" value="<%=s_br_id%>">
<input type="hidden" name="s_dept_id_id" value="<%=s_dept_id%>">
<input type="hidden" name="s_start_dt" value="<%=s_start_dt%>">
<input type="hidden" name="s_gubun" value="<%=s_gubun%>">
<input type="hidden" name="s_mng_who" value="<%=s_mng_who%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line>            
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
              <%for(int i = 0 ; i < add_size ; i++){
    				Hashtable add = (Hashtable)adds.elementAt(i);
    				String gubun=String.valueOf(add.get("GUBUN"));
    				String mng_who=String.valueOf(add.get("MNG_WHO"));
    				String mng_way=String.valueOf(add.get("MNG_WAY"));
    				String mng_st=String.valueOf(add.get("MNG_ST"));%>
              <!--수정-->
                <input type="hidden" name="u_seq" value="<%=add.get("SEQ")%>">
                <tr> 
                    <td align="center" width=10%><%=c_db.getNameById(String.valueOf(add.get("BR_ID")), "BRCH")%></td>
                    <td align="center" width=10%><%if(String.valueOf(add.get("DEPT_ID")).equals("0000")){%>전체<%}else{%><%=c_db.getNameById(String.valueOf(add.get("DEPT_ID")), "DEPT")%><%}%></td>
                    <td align="center" width=10%> 
        			  <%if(gubun.equals("0001")){%>관리현황
        			  <%}else if(gubun.equals("0002")){%>영업현황
        			  <%}else if(gubun.equals("0003")){%>인사평점<%}%>			  
                    </td>
                    <td align="center" width=9%> 
                      <%if(mng_who.equals("1")){%>업체
                      <%}else if(mng_who.equals("2")){%>차량
                      <%}else if(mng_who.equals("3")){%>계약	  
                      <%}else if(mng_who.equals("4")){%>연체<%}%>			  			  
                    </td>
                    <td align="center" width=11%>
        			  <%if(mng_way.equals("0")){%>전체
        			  <%}else if(mng_way.equals("1")){%>일반식
        			  <%}else if(mng_way.equals("2")){%>맞춤식
        			  <%}else if(mng_way.equals("3")){%>기본식
        			  <%}else if(mng_way.equals("9")){%>기본식/맞춤식<%}%>			  
                    </td>
                    <td align="center" width=13%>
        			  <%if(mng_st.equals("1")){%>단독
        			  <%}else if(mng_st.equals("2")){%>공동
        			  <%}else if(mng_st.equals("3")){%>최초영업
        			  <%}else if(mng_st.equals("4")){%>영업관리
        			  <%}else if(mng_st.equals("5")){%>정비관리
        			  <%}else if(mng_st.equals("6")){%>신규계약
        			  <%}else if(mng_st.equals("7")){%>대차계약
        			  <%}else if(mng_st.equals("8")){%>증차계약
        			  <%}else if(mng_st.equals("9")){%>연장계약
        			  <%}else if(mng_st.equals("10")){%>보유차(6개월이상)
        			  <%}else if(mng_st.equals("11")){%>연체율-기
        			  <%}else if(mng_st.equals("12")){%>연체율-변	  			  
        			  <%}else if(mng_st.equals("13")){%>관리-변	  			  			  
        			  <%}else if(mng_st.equals("")){%>-<%}%>			  
                    </td>
                    <td align="center" width=10%> 
                      <input type="text" name="u_marks" size="5" class="num" value="<%=String.valueOf(add.get("MARKS"))%>">
                      점</td>
                    <td align="center" width=20%> 
                      <%=AddUtil.ChangeDate2((String)add.get("START_DT"))%>
                      ~ 
                      <input type="text" name="u_end_dt" size="9" class="text" value="<%=AddUtil.ChangeDate2((String)add.get("END_DT"))%>">
                    </td>
                    <td align="center" width=7%> 
        			<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>			
                      <a href="javascript:update('<%=i%>');"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>
        			<%	}%>			  
                    </td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>