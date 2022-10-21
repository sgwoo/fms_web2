<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	
	Vector conts = new Vector();
	int cont_size = 0;
	
	if(!t_wd.equals("") || !s_cd.equals("")){
		conts = rs_db.getAccidCarSearchList(c_id, s_cd, firm_nm, t_wd);
		cont_size = conts.size();
	}
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function search(){
		document.form1.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
	
	function SetCarAccid(accid_st, car_mng_id, accid_id, serv_id, off_nm, accid_dt, car_no, car_nm, our_num, ins_nm, ins_mng_nm){
		var ofm = opener.document.form1;
		var fm = document.form1;		
		ofm.accid_id.value = accid_id;
		ofm.sub_c_id.value = car_mng_id;
		ofm.off_nm.value = off_nm;
		ofm.accid_car_no.value = car_no;		
		self.close();				
	}
//-->
</script>
</head>
<body leftmargin="15" javascript="document.form1.t_wd.focus();">
<table border=0 cellspacing=0 cellpadding=0 width=800>
  <form name="form1" method="post" action="sub_select_3_a2.jsp">
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량번호 : </span>
			<input type='text' name='t_wd' size='15' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()'>
		    <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td  class=line>
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="30">연번</td>
                    <td class=title width="120">상호</td>										
                    <td class=title width="80">차량번호</td>					
                    <td class=title width="70">사고일자</td>
                    <td class=title width="70">사고구분</td>
                    <td class=title width="200">사고장소</td>
                    <td class=title width="230">사고내용</td>
                </tr>
				<%	if(cont_size > 0){
						for(int i = 0 ; i < cont_size ; i++){
							Hashtable sfm = (Hashtable)conts.elementAt(i);%>
        		<tr> 
       		      <td align="center"><%=i+1%></td>
       		      <td align="center"><%=sfm.get("FIRM_NM")%></td>				  				  				  
       		      <td align="center"><%=sfm.get("P_CAR_NO")%></td>				  
       		      <td align="center"><a href="javascript:SetCarAccid('<%=sfm.get("ACCID_ST2")%>', '<%=sfm.get("CAR_MNG_ID")%>', '<%=sfm.get("ACCID_ID")%>', '<%=sfm.get("SERV_ID")%>', '<%=sfm.get("OFF_NM")%>', '<%=AddUtil.ChangeDate2(String.valueOf(sfm.get("ACCID_DT")))%>' ,'<%=sfm.get("P_CAR_NO")%>' ,'<%=sfm.get("P_CAR_NM")%>' ,'<%=sfm.get("P_NUM")%>' ,'<%=sfm.get("G_INS")%>' ,'<%=sfm.get("G_INS_NM")%>')"><%=AddUtil.ChangeDate2(String.valueOf(sfm.get("ACCID_DT")))%></a></td>
       		      <td align="center"><%=sfm.get("ACCID_ST")%></td>
       		      <td align="center"><%=sfm.get("ACCID_ADDR")%></td>
       		      <td align="center"><%=sfm.get("ACCID_CONT")%></td>
        	    </tr>							
				<%		}
			  		}else{%>
				<tr> 
                  <td colspan=7 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>	
				<%	}%>	
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>