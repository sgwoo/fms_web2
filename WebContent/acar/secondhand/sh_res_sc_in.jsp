<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.user_mng.*"%>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String sh_height 	= request.getParameter("sh_height")==null?"0":request.getParameter("sh_height");
		
	Vector vt = shDb.getShResMngList(s_kd, t_wd, gubun1, gubun2, gubun3, gubun4);  
	int cont_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title ���� */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ;
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;
	}
	
	function init(){
		setupEvents();
	}	

	function EstiMemo(est_id, user_id, chk, bb_chk, t_chk){
		var fm = document.estiSpeFrm;
		fm.t_chk.value = t_chk;
		fm.bb_chk.value = bb_chk;
		fm.chk.value = chk;
		fm.est_id.value = est_id;
		fm.user_id.value = user_id;
		fm.target = "d_content"
		fm.action = "/acar/estimate_mng/esti_spe_hp_i.jsp";
		fm.submit();
	}

//-->
</script>
</head>
<body onLoad="javascript:init()">
<form name="estiSpeFrm" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">  
	<input type="hidden" name="user_id" value="">         
	<input type="hidden" name="est_id" value="">       
	<input type="hidden" name="t_chk" value="">  
	<input type="hidden" name="bb_chk" value="">  
	<input type="hidden" name="chk" value=""> 
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  <input type='hidden' name='andor' value='<%=andor%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' value='<%=gubun5%>'>	
	<input type="hidden" name="from_page" value="/acar/secondhand/sh_res_frame.jsp"> 
</form>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  <input type='hidden' name='andor' value='<%=andor%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/acar/secondhand/sh_res_frame.jsp'>
  <input type='hidden' name='ext_est_dt' value=''>  
  <table border="0" cellspacing="0" cellpadding="0" width='1730'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='600' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                  <td width='50' class='title'>����</td>
                  <td width='100' class='title'>������ȣ</td>
                  <td width='150' class='title'>����</td>
                  <td width="80" class='title'>��������</td>
                  <td width="80" class='title'>����</td>
                  <td width="30" class="title">����</td>
                  <td width="80" class='title'>�������</td>
                  <td width="80" class='title'>�����Ȳ</td>
                </tr>
            </table>
    	</td>
	    <td class='line' width='1070'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        	    <tr>
        	    	<td width="100" class='title'>��������ġ</td>
        	    	<td width="100" class='title'>��������</td>
       	    	    <td width="200" class='title'>����</td>
       		        <td width="110" class='title'>����ó</td>
       		        <td width="160" class='title'>����Ⱓ</td>
       		        <td width="250" class='title'>�޸�</td>
       		        <td width="70" class='title'>�����</td>
       		        <td width="150" class='title'>����Ͻ�</td>
        	    </tr>
	        </table>
	    </td>
    </tr>
  <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='600' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%
            	int rank = 1;
            	String tempCarId ="";
            	
            	for(int i = 0 ; i < cont_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					String td_color = "";
					if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
					String carNo = (String)ht.get("CAR_NO");
					//���� ���� ���
					if(tempCarId.equals(carNo)){
						rank ++;
					}else{
					    tempCarId = carNo;
					    rank = 1;
					}
					
			%>
                <tr> 
                  <td <%=td_color%> width='50' align='center'><%=i+1%></td>
                  <td <%=td_color%> width='100' align='center'>
                  	<%
                  	  String estiGubun = "";
                  	  if(ht.get("EST_ID") != null && ht.get("EST_ID") != ""){
                  	  	estiGubun = "(HP)";
                  	      //Ȩ���������� �� ����Ʈ�� esti_spe_hp_i.jsp �� �̵��Ѵ�%>
                  	  	
                  		<a href="javascript:EstiMemo('<%=ht.get("EST_ID")%>','<%=ck_acar_id%>','1','','');" title="�̷�">
                  	<%}else{ %>
                  		<a href="javascript:parent.view_sh_res('<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("CAR_ST")%>','<%=ht.get("RES_ST")%>','<%=ht.get("USE_ST")%>')" title="�̷�">
                  	<%} %>
                  		<%=ht.get("CAR_NO")%>
                  	</a>
                  </td>
                  <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 11)%></span></td>
                  <td <%=td_color%> width='80' align='center'><%=ht.get("CAR_ST")%></td>
                  <td <%=td_color%> width='80' align='center'><%=ht.get("RES_ST")%><%=estiGubun%></td>
                  <td <%=td_color%> width='30' align='center'><%if(gubun1.equals("3")){%> - <%}else{%><%=rank%><%}%></td>
                  <td <%=td_color%> width='80' align='center'><%=ht.get("USE_ST")%></td>
                  <td <%=td_color%> width='80' align='center'><%=ht.get("SITUATION_ST")%></td>
                </tr>
        <%		}	%>
            </table>
	    </td>
	    <td class='line' width='1070'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<%	
        			for(int i = 0 ; i < cont_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						String td_color = "";
						if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=is ";
						
				%>
        		<tr>
        		  <td <%=td_color%> width='100' align='center'><!-- ��������ġ -->
        		  	<%
        		  		String car_no = (String)ht.get("CAR_NO");
	        		  	Vector vt2 = shDb.getCarCurrentArea(car_no);  
	        			int vt2_size = vt2.size();
	        			for(int j = 0 ; j < 1 ; j++){	//<--��࿡ ���� ������ġ �̹Ƿ� ���� �ֽ� �� �Ǹ� �������� ������ġ�� ��.
							Hashtable ht2 = (Hashtable)vt2.elementAt(j);
        		  			String c_a_nm = (String)ht2.get("BR_NM");
	        		  		if(String.valueOf(ht2.get("BR_NM")).equals("") || ht2.get("BR_NM")==null){
	        		  	 %><%-- (<%=ht2.get("BR_ID")%>) --%>
	        		  	 <%}else{%><%=ht2.get("BR_NM")%><%}%>
	        		 <%	}%> 
        		  </td>
        		  <td <%=td_color%> width='100' align='center'>
        		  <% 	String brId = (String)ht.get("BR_ID");
        		  		String branch = ""; 
        		  		
        		  		if(brId.equals("")){
        		  			String est_area = (String)ht.get("EST_AREA1");
        		  			String county = (String)ht.get("EST_AREA2");
        		  			
        		  			
        		  			
        		  			if(est_area.equals("�����")) 		est_area = "����";
        		  			if(est_area.equals("�λ��")) 		est_area = "�λ�";
        		  			if(est_area.equals("��õ������")) est_area = "��õ";
        		  			if(est_area.equals("����Ư����ġ��")) est_area = "����";
        		  			
        		  			//��������8
										if(est_area.equals("����")){
											if(county.equals("������")||county.equals("���ʱ�")||county.equals("������")){
												branch = "����";
											}else if(county.equals("���α�")||county.equals("���빮��")||county.equals("�߱�")||county.equals("��걸")||county.equals("�߶���")||county.equals("�����")||county.equals("���ϱ�")||county.equals("���빮��")||county.equals("����")||county.equals("������")||county.equals("���ϱ�")) {
												branch = "����";
											}else if(county.equals("���ı�")||county.equals("������")||county.equals("������")) {
												branch = "����";
											}else{
												branch = "����";
											}
										}else if(est_area.equals("��õ")){
											branch = "��õ";
										}else if(est_area.equals("���")){
											if(county.equals("��õ��")){
												branch = "����";
											}else if(county.equals("������")||county.equals("��õ��")||county.equals("�����")){
												branch = "��õ";
											}else if(county.equals("������")||county.equals("������")||county.equals("�Ȼ��")||county.equals("�ȼ���")||county.equals("���ֱ�")||county.equals("�����")||county.equals("���ν�")||county.equals("�ǿս�")||county.equals("��õ��")||county.equals("���ý�")||county.equals("ȭ����")){
												branch = "����";
											}else if(county.equals("����")||county.equals("������")||county.equals("�ϳ���")||county.equals("���ֽ�")||county.equals("�����ֽ�")||county.equals("����")||county.equals("������")){
												branch = "����";
											}else if(county.equals("����õ��")||county.equals("���ֽ�")||county.equals("��õ��")||county.equals("�����ν�")||county.equals("��õ��")){
												branch = "����";
											}else{
												branch = "����";
											}
										}else if(est_area.equals("����")){
											if(county.equals("��õ��")||county.equals("�籸��")||county.equals("ö����")||county.equals("ȭõ��")||county.equals("ȫõ��")||county.equals("������")||county.equals("����")||county.equals("���ʽ�")||county.equals("��籺")){
												branch = "����";
											}else{
												branch = "����";
											}
										}else if(est_area.equals("�泲")||est_area.equals("�λ�")||est_area.equals("���")){
											branch = "�λ�";
										}else if(est_area.equals("����")||est_area.equals("����")||est_area.equals("����")||est_area.equals("����")){
											branch = "����";
										}else if(est_area.equals("�뱸")||est_area.equals("���")){
											branch = "�뱸";
										}else if(est_area.equals("�泲")||est_area.equals("���")||est_area.equals("����")||est_area.equals("����")||est_area.equals("����Ư����ġ��")){
											branch = "����";
										}
        		  		}
        		  		
        		  		
        		  %>
        		  <%if(String.valueOf(ht.get("RES_ST")).equals("����Ʈ") ){ // ����Ʈ ���� ���������� ���� ����ġ�� ���� %>
       		  		<% for(int j = 0 ; j < 1 ; j++){	//<--��࿡ ���� ������ġ �̹Ƿ� ���� �ֽ� �� �Ǹ� �������� ������ġ�� ��.
						Hashtable ht2 = (Hashtable)vt2.elementAt(j);
	        		  		if( !(String.valueOf(ht2.get("BR_NM")).equals("") || ht2.get("BR_NM")==null ) ){
	        		  	 %>
	        		  	 	<% // ����Ʈ �߿����� �������� ��쿡�� �� �ּҸ� ���󰡵���. 2021.11.08.
	        		  	 		if(String.valueOf(ht2.get("BR_NM")).equals("������")){ 
	        		  	 	%>
	        		  	 		<% if(brId.equals("S1")){ %> ����
		        		  		<% } else if(brId.equals("B1")){ %>�λ� 
		        		  		<% } else if(brId.equals("D1")){ %>����
		        		  		<% } else if(brId.equals("S2")){ %>����
		        		  		<% } else if(brId.equals("J1")){ %>����
		        		  		<% } else if(brId.equals("G1")){ %>�뱸
		        		  		<% } else if(brId.equals("I1")){ %>��õ
		        		  		<% } else if(brId.equals("K3")){ %>����
		        		  		<% } else if(brId.equals("U1")){ %>���
		        		  		<% } else if(brId.equals("S5")){ %>��ȭ��
		        		  		<% } else if(brId.equals("S6")){ %>���� 
		                  		<% } else{%><%=branch%>
		                  		<% } %>
	        		  	 	<%} else{%>
	        		  	 		<%=ht2.get("BR_NM")%>
	        		  	 	<%}%>
	        		  	 <%}%>
        			<%}%> 
        		  <%} else { // �縮�� %>
        		  		<% if(brId.equals("S1")){ %> ����
        		  		<% }else if(brId.equals("B1")){ %>�λ� 
        		  		<% }else if(brId.equals("D1")){ %>����
        		  		<% }else if(brId.equals("S2")){ %>����
        		  		<% }else if(brId.equals("J1")){ %>����
        		  		<% }else if(brId.equals("G1")){ %>�뱸
        		  		<% }else if(brId.equals("I1")){ %>��õ
        		  		<% }else if(brId.equals("K3")){ %>����
        		  		<% }else if(brId.equals("U1")){ %>���
        		  		<% }else if(brId.equals("S5")){ %>��ȭ��
        		  		<% }else if(brId.equals("S6")){ %>���� 
                  		<% }else{%><%=branch%>
                  		<% } %>
        		  <%} %>
        		  </td> 
        		  <td <%=td_color%> width='200' align='center'><span title='<%=ht.get("CUST_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CUST_NM")), 15)%></span></td> 
        		  <td <%=td_color%> width='110' align='center'><span title='<%=AddUtil.phoneFormat(String.valueOf(ht.get("CUST_TEL")))%>'><%=AddUtil.subData(AddUtil.phoneFormat(String.valueOf(ht.get("CUST_TEL"))), 13)%></span></td>
        		  <td <%=td_color%> width='160' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RES_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RES_END_DT")))%></td>
        		  <td <%=td_color%> width='250'>&nbsp;<span title='<%=ht.get("MEMO")%>'><%=AddUtil.subData(String.valueOf(ht.get("MEMO")), 20)%></span></td>
        		  <td <%=td_color%> width='70' align='center'><%=ht.get("USER_NM")%></td>
	       		  <td <%=td_color%> width='150' align='left'>
	       		  <% if(!String.valueOf(ht.get("REG_TIME")).equals("")){ %>
	       		  		&nbsp;&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(ht.get("REG_TIME")))%> <!-- Ȩ������ ����Ʈ ������̸� �ð����� �ٺ����� -->
	       		  <%		
	       		  	 }else{
	       		  %>		 
	       		  		&nbsp;&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
	       		  <%		
	       		  	 }
	       		  %>
	       		  </td>
        		</tr>
						<%	}	%>
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='600' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='850'>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
  	        </table>
	    </td>
    </tr>
<%	}	%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=cont_size%>';
//-->
</script>
</body>
</html>


