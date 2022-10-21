<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	Vector vt = new Vector();
	
	vt = ec_db.getComDirDocList(s_kd, t_wd, s_dt, e_dt, gubun1, gubun2, gubun3);
	
	int cont_size = vt.size();
	
	int count =0;
%>

<html lang='ko'>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'>    
  <input type='hidden' name='s_dt'  	value='<%=s_dt%>'>
  <input type='hidden' name='e_dt' 	value='<%=e_dt%>'>			
  <input type='hidden' name='from_page' value='/fms2/bus_analysis/com_dir_doc_frame.jsp'>
  <input type='hidden' name='from_page2' value='/fms2/bus_analysis/com_dir_doc_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='est_id' value=''>
  <input type='hidden' name='set_code' value=''>  
  <input type='hidden' name='c_st' value='emp'>  
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>		
        <td class='line' width='100%'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>    
                <tr> 
                    <td width='3%' class='title'>연번</td>
                    <td width='10%' class='title'>계약번호</td>
                    <td width='7%' class='title'>계약일</td>
                    <td width='7%' class='title'>대여개시일</td>
                    <td width="13%" class='title'>고객</td>
        	        <td width="7%" class='title'>차량번호</td>
        	        <td width="10%" class='title'>차종</td>
        	        <td width="5%" class='title'>계약구분</td>
        	        <td width="5%" class='title'>영업구분</td>
        	        <td width='6%' class='title'>출고보전수당</td>
        	        <td width='8%' class='title'>실적이관구분</td>
       	            <td width='5%' class='title'>최초영업자</td>
        	        <td width='10%' class='title'>등록일시</td>        	           	    
        	        <td width='4%' class='title'>-</td>
       		    </tr>                                
                <%if(cont_size > 0){%>
                <%	for(int i = 0 ; i < cont_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
		        %>					
                <tr> 
                    <td align='center'><%=i+1%></td>                    
                    <td align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>')" onMouseOver="window.status=''; return true" title='계약상세내역'><%=ht.get("RENT_L_CD")%></a></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>                    
                    <td align='center'><%=ht.get("FIRM_NM")%></td>
        	        <td align='center'><%=ht.get("CAR_NO")%></td>        	    
        	        <td align='center'><%=ht.get("CAR_NM")%></td>
        	        <td align='center'><%=ht.get("RENT_ST")%></td>
        	        <td align='center'><%=ht.get("BUS_ST")%></td>
        	        <td align='center'><%=ht.get("DLV_CON_COMMI_YN")%></td>
        	        <td align='center'><%=ht.get("DIR_PUR_COMMI_YN")%></td>
        	        <td align='center'><%=ht.get("BUS_NM")%></td>
       		        <td align='center'>
       		            <%if(String.valueOf(ht.get("BUS_ST")).equals("에이젼트")){%>
       		                            입력대상 아님
       		            <%}else{%>
       		            	<a href ="javascript:parent.reg_doc('<%=ht.get("DOC_NO")%>','17','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')">
       		        			<%=ht.get("USER_DT1")%>
       		        		</a>
       		        	<%}%>
       		        </td>
                    <td align='center'>
       		            <%if(String.valueOf(ht.get("BUS_ST")).equals("에이젼트")){%>
       		                -
       		            <%}else{%>
       		                <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
       		        		<a href ="javascript:parent.reg_doc('<%=ht.get("DOC_NO")%>','17','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')">
       		        			<img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0>
       		        		</a>
       		        		<%}else{%>
       		        		<a href ="javascript:parent.upd_doc('<%=ht.get("DOC_NO")%>','17','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')">
       		        			<img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0>
       		        		</a>
       		        		<%}%>
       		        	<%}%>
       		        </td>       		        
                </tr>                
                <%	}%>                
                <%}else{%>
                <tr> 
                    <td colspan='14' align='center'><%if(t_wd.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
                <%}%>
            </table>
	</td>
    </tr>	
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=cont_size%>';
//-->
</script>
</body>
</html>

