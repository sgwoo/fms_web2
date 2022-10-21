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
	
	vt = ec_db.getBusAnalysisStatList(s_kd, t_wd, s_dt, e_dt, gubun1, gubun2, gubun3);
	
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
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}		
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
  <input type='hidden' name='from_page' value='/fms2/bus_analysis/ba_stat_frame.jsp'>
  <input type='hidden' name='from_page2' value='/fms2/bus_analysis/ba_stat_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='est_id' value=''>
  <input type='hidden' name='set_code' value=''>  
  <input type='hidden' name='c_st' value='etc'>  
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>		
        <td class='line' width='100%'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
    
                <%if(gubun3.equals("1")){%>
                <tr> 
                    <td width='3%' class='title'>����</td>
                    <td width=3% class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                    <td width='3%' class='title'>����</td>
                    <td width='9%' class='title'>����ȣ</td>
                    <td width='7%' class='title'>�����</td>
                    <td width="10%" class='title'>��</td>
        	    <td width="10%" class='title'>����</td>
        	    <td width="5%" class='title'>��������</td>
        	    <td width="5%" class='title'>��౸��</td>
        	    <td width="5%" class='title'>�뵵����</td>
        	    <td width="5%" class='title'>��������</td>
       	            <td width='6%' class='title'>���ʿ�����</td>
        	    <td width='22%' class='title'>�����Ȳ-�������</td>        	    
        	    <td width='7%' class='title'>����Ͻ�</td>        	    
       		</tr>                
                <%}else{%>
                <tr> 
                    <td width='3%' class='title'>����</td>
                    <td width=3% class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                    <td width='3%' class='title'>����</td>
                    <td width='7%' class='title'>��������</td>
                    <td width='10%' class='title'>��</td>
                    <td width="10%" class='title'>����</td>
                    <td width="5%" class='title'>��������</td>
                    <td width='12%' class='title'>��ǰ</td>
                    <td width="6%" class='title'>�뿩�Ⱓ</td>        	
       	            <td width='7%' class='title'>���������</td>
        	    <td width='30%' class='title'>�����Ȳ-�̰������</td>       	    
        	    <td width='24%' class='title'>����Ͻ�</td>       	            	    
       		</tr>
                <%}%>
                
                <%if(cont_size > 0){%>
                <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
				
				if(String.valueOf(ht.get("BUS_CAU")).equals("")) continue;
				
				count++;
		%>
				
		<%if(gubun3.equals("1")){%>		
                <tr> 
                    <td <%=td_color%> align='center'><%=count%></td>
                    <td <%=td_color%> align='center'>
                        <%if(String.valueOf(ht.get("BUS_CAU_SCORE")).equals("") || String.valueOf(ht.get("BUS_CAU_SCORE")).equals("0")){%>
                        <input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_L_CD")%>|<%=ht.get("FIRM_NM")%>|<%=ht.get("USER_NM")%>|<%=ht.get("BUS_CAU_SCORE")%>|<%=ht.get("BUS_CAU")%>">
                        <%}%>
                    </td>
                    <td <%=td_color%> align='center'><%if(!String.valueOf(ht.get("BUS_CAU_SCORE")).equals("0")){%><%=ht.get("BUS_CAU_SCORE")%><%}%></td>
                    <td <%=td_color%> align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>')" onMouseOver="window.status=''; return true" title='���󼼳���'><%=ht.get("RENT_L_CD")%></a></td>
                    <td <%=td_color%> align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                    <td <%=td_color%> align='center'><%=ht.get("FIRM_NM")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("CAR_NAME")%></td>        	    
        	    <td <%=td_color%> align='center'><%=ht.get("CAR_GU")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("RENT_ST")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("CAR_ST")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("RENT_WAY")%></td>
       		    <td <%=td_color%> align='center'><%=ht.get("USER_NM")%></td>
        	    <td <%=td_color%> align='left'>&nbsp;<%=ht.get("BUS_CAU")%></td>                    
        	    <td <%=td_color%> align='center'><%=ht.get("BUS_CAU_DT")%></td>
                </tr>
                <%}else{%>
                <tr>                 
                    <td <%=td_color%> align='center'><%=count%></td>
                    <td <%=td_color%> align='center'>
                        <%if(String.valueOf(ht.get("BUS_CAU_SCORE")).equals("") || String.valueOf(ht.get("BUS_CAU_SCORE")).equals("0")){%>
                        <input type="checkbox" name="ch_cd" value="<%=ht.get("EST_ID")%>|<%=ht.get("EST_NM")%>|<%=ht.get("USER_NM")%>|<%=ht.get("BUS_CAU_SCORE")%>|<%=ht.get("BUS_CAU")%>"></td>
                        <%}%>
                    <td <%=td_color%> align='center'><%if(!String.valueOf(ht.get("BUS_CAU_SCORE")).equals("0")){%><%=ht.get("BUS_CAU_SCORE")%><%}%></td>    
                    <td <%=td_color%> align='center'><a href="javascript:parent.EstiDisp('<%=ht.get("EST_TYPE")%>','<%=ht.get("EST_ID")%>','<%=ht.get("SET_CODE")%>')" onMouseOver="window.status=''; return true" title='���󼼳���'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></a></td>                    
                    <td <%=td_color%> align='center'><%=ht.get("EST_NM")%></td>
                    <td <%=td_color%> align='center'><%=ht.get("CAR_NAME")%></td>        	    
        	    <td <%=td_color%> align='center'><%=ht.get("CAR_GU")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("NM")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("A_B")%>����</td>        	    
       		    <td <%=td_color%> align='center'><%=ht.get("USER_NM")%></td>
        	    <td <%=td_color%> align='left'>&nbsp;<%=ht.get("BUS_CAU")%></td>  
        	    <td <%=td_color%> align='center'><%=ht.get("BUS_CAU_DT")%></td>              
                </tr>
                <%}%>
                <%	}%>                
                <%}else{%>
                <tr> 
                    <td colspan='<%if(gubun3.equals("1")){%>14<%}else{%>12<%}%>' align='center'><%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
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

