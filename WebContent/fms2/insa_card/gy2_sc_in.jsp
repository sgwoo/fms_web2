<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.insa_card.*" %>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//고용현황2
	
	String basic_dt = request.getParameter("basic_dt")==null?"":request.getParameter("basic_dt");

	Vector vt1 = new Vector();
	if(!basic_dt.equals("")){
		vt1 = ic_db.gy2list_in_yeardate(basic_dt);
	}
	int vt1_size = vt1.size();
	
	int f_year 	= AddUtil.getDate2(1);	
	int l_year = AddUtil.getDate2(1)-4;
	int year_cnt = 8; 
	
	int td_width = 120;		
	
	if(l_year < 2018){
		l_year = 2018;
	}
	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function search(){
	var fm = document.form1;
	fm.action = 'gy2_sc_in.jsp';
	fm.target = "_self";
	fm.submit();
}
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<table border="0" cellspacing="0" cellpadding="0" width="<%=td_width*10%>">
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>직군/근속현황 조회</span>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         ○ 기준일자 : 
         <select name="basic_dt">
             <%for (int j = f_year ; j >= l_year ; j--){%>                  
             <OPTION VALUE="<%=j%>" <%if(basic_dt.equals(String.valueOf(j))){%>selected<%}%>><%=j%>년</OPTION>
			 <%}%>
         </select>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         <a href="javascript:search()"><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a>         
      </td>
      <td align="right">※ 당해는 현재 기준, 당해 이전은 매년 12월31일 마감기준으로 조회 되었습니다.</td>
    </tr>
    <tr>
		<td colspan='2'>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr><td class=line2 ></td></tr>
		        <TR id='tr_title'>
		        	<td class='line2' id='td_title'>
		        		<table border="0" cellspacing="1" cellpadding="0" width=100%>
		        			<tr>
					          <TD rowspan='2' colspan="2" class='title'>구분</TD>					          
					          <TD colspan="2" class='title'>근무형태별현황</TD>
					          <TD colspan="6" class='title'>근속년수별현황</TD>
		        			</TR>
		        			<tr>
                              <td width="<%=td_width%>" class=title>내근직</td>
                              <td width="<%=td_width%>" class=title>외근직</td>
                              <td width="<%=td_width%>" class=title>1년미만</td>
                              <td width="<%=td_width%>" class=title>1년이상~3년미만</td>
                              <td width="<%=td_width%>" class=title>3년이상~5년미만</td>
                              <td width="<%=td_width%>" class=title>5년이상~10년미만</td>
                              <td width="<%=td_width%>" class=title>10년이상</td>
                              <td width="<%=td_width%>" class=title>합계</td>
		        			</TR>
		        			<%	for(int i = 0 ; i < vt1_size ; i++){
									Hashtable ht = (Hashtable)vt1.elementAt(i);
							%>
					        <TR>
					          <TD rowspan="2" width="<%=td_width%>" class='title'><%=ht.get("USER_FM")%></TD>
					          <TD width="<%=td_width%>" class='title'>인원</TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD align="center" <%if(String.valueOf(ht.get("USER_FM")).equals("합계")){%>class='title'<%}%>><%=ht.get("CNT"+(j))%>&nbsp;명</TD>
					          <%}%>
				            </TR>		
				            <TR>
					          <TD width="<%=td_width%>" class='title'>비중</TD>
					          <%for (int j = 1 ; j <= year_cnt ; j++){ %>
					          <TD align="center" <%if(String.valueOf(ht.get("USER_FM")).equals("합계")){%>class='title'<%}%>><%=ht.get("PER"+(j))%>&nbsp;%</TD>
					          <%}%>
				            </TR>																	            								
							<%	}%>
						</TABLE>
					</td>
				</tr>
			</table>
		</td>
    </tr>

</table>
</form>
</body>
</html>