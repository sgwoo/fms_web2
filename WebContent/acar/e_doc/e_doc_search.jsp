<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*,acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String document_st = request.getParameter("document_st") == null ? "" : request.getParameter("document_st");
	String document_type = request.getParameter("document_type") == null ? "" : request.getParameter("document_type");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	  br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "07");
	
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
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")==null?0:AddUtil.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//�����Ҹ���Ʈ
	Vector branches = c_db.getUserBranchs("rent"); 			//������ ����Ʈ
	int brch_size = branches.size();
	
	String white = "";
	String disabled = "";
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(nm_db.getWorkAuthUser("�Ƹ���ī�̿�",user_id)){
		white = "white";
		disabled = "disabled";
	}
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	//�˻��ϱ�
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	// ��� �� ���� �� ó��
	function set_e_doc( rent_mng_id, rent_l_cd, fee_rent_st, status, client_id, car_st ){
		var document_st = '<%=document_st%>';
		var document_type = '<%=document_type%>';
		
		var from_page;
		
		if( document_st == '1' ){
			if( document_type == '1' ){
				if( !(status =='�ű�' || status == '����' || status == '����' || car_st == '�����뿩') ){
					alert('�ű� ��� ���� ������ �ּ���.');
					return;
				}
			} else if( document_type == '2' ){
				if( status != '���°�' ){
					alert('�°� ��� ���� ������ �ּ���.');
					return;
				}
			} else if( document_type == '3' ){
				if( status != '����' ){
					alert('���� ��� ���� ������ �ּ���.');
					return;
				}
			}
			
			from_page = 'cont_doc_send.jsp';
		
		} else if( document_st == '' ){
			from_page = 'confirm_doc_send.jsp';
		}
		
		
		window.opener.location.href = from_page+"?user_id="+<%=user_id%>+"&document_st="+document_st+"&document_type="+document_type+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+fee_rent_st+"&status="+status+"&client_id="+client_id+"&car_st="+car_st;
// 		window.opener.set_e_doc(document_st, document_type, rent_mng_id, rent_l_cd, fee_rent_st, status, client_id, car_st);
		window.close();
	}
	
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>  
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǰ˻�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <%	if(document_st.equals("1") && !document_type.equals("4")){ 	// �ű�/�°�/���� ��༭.	�̰���� �޴� �˻��� ���� %>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>�˻�����</td>
                    <td width=40%>&nbsp;
            			<select name='s_kd'>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>������ȣ </option>
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>�����ȣ </option>
                          <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>�����ȣ </option>
						  <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>�������� </option>
						  <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>���ʿ����� </option>
						  <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>���� </option>
						  
                        </select>
                        &nbsp;&nbsp;&nbsp;
            			<input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>            		
        		    </td>
                    <td class=title width=10%>��������</td>
                    <td width=15%>&nbsp;
            		    <select name='gubun2'>
                          <option value=''>��ü</option>
                          <%	if(brch_size > 0)	{
            						for (int i = 0 ; i < brch_size ; i++){
            							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                          <option value='<%=branch.get("BR_ID")%>' <%if(gubun2.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                          <%		}
            					}%>
                        </select></td>		  		  
        
                </tr>
            </table>
        </td>
    </tr>
    <tr align="right">
        <td><a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
    	<td style='height: 30px;'></td>
    </tr>
    <tr>
    	<td class='line'>
    	<table border=0 cellspacing=1 width=100%>
    		<tr>
    			<td class='title title_border'>����</td>
    			<td class='title title_border'>����</td>
    			<td class='title title_border'>����ȣ</td>
    			<td class='title title_border'>�����<br>(�°�����)</td>
    			<td class='title title_border'>��</td>
    			<td class='title title_border'>�뿩������</td>
    			<td class='title title_border'>��౸��</td>
    			<td class='title title_border'>�뵵����</td>
    		</tr>
    		<%
	    		// �̰��� ����Ʈ: ���ڹ��� �߼� ��� ����Ʈ ����
	    		Vector lc_b_vt = a_db.getHoldContListForEdoc(s_kd, t_wd, gubun2, document_st, document_type);
// 	    		Vector lc_b_vt = a_db.getHoldContList_20160614(s_kd, t_wd, andor, gubun2, gubun3);
	    		int lc_b_vt_size = lc_b_vt.size();
    		%>
    		<% if(lc_b_vt_size > 0){ %>
	    		<% for(int i=0; i < lc_b_vt_size; i++){ 
	    			Hashtable ht = (Hashtable)lc_b_vt.elementAt(i);
	    			if(String.valueOf(ht.get("CAR_ST")).equals("����Ʈ")) continue;
	    		%>
		    		<tr>
		    			<td class='center content_border'><%=i+1%></td>
		    			<td class='center content_border'><%if(String.valueOf(ht.get("SANCTION_ST")).equals("��û")){%><font color=red><%=ht.get("SANCTION_ST")%><%if(a_db.getSanctionUserType(String.valueOf(ht.get("BUS_ID")),String.valueOf(ht.get("BUS_NM"))) == 1){%>2<%}%></font><%}else{%><font color=#000000><%=ht.get("SANCTION_ST")%></font><%}%></td>
		    			<td class='center content_border'><a href="javascript:set_e_doc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>', '<%if(String.valueOf(ht.get("CNG_ST")).equals("")){%><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%><%}else{%><%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%><%}else{%><%=ht.get("EXT_ST2")%><%}%><%}%>', '<%=ht.get("CLIENT_ID")%>','<%=ht.get("CAR_ST")%>');" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
		    			<td class='center content_border'>
		    				<%if(String.valueOf(ht.get("CNG_ST")).equals("���°�") && String.valueOf(ht.get("EXT_ST2")).equals("")){%>
			                    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%>
	                        <%}else{%>
	                            <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>
	                        <%}%>
		    			</td>
		    			<td class='center content_border'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></td>
		    			<td class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
		    			<td class='center content_border'>
		    				<%if(String.valueOf(ht.get("CNG_ST")).equals("")){%>
								<%if(String.valueOf(ht.get("EXT_ST")).equals("")){%>
									<%=ht.get("RENT_ST")%>
								<%}else{%>
									<%=ht.get("EXT_ST")%>
								<%}%>
							<%}else{%>
								<%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%>
									<%=ht.get("CNG_ST")%>
								<%}else{%>
									<%=ht.get("EXT_ST2")%>
								<%}%>
							<%}%>
		    			</td>
		    			<td class='center content_border'><%=ht.get("CAR_ST")%></td>
		    		</tr>
	    		<%} %>
    		<%} else{%>
   				<tr>
					<td class='center content_border' colspan='8' style='text-align: center;'>��ϵ� �����Ͱ� �����ϴ�</td>
				</tr>	
    		<%} %>
    	</table>
    	</td>
    </tr>
    <%} else if(document_st.equals("1") && document_type.equals("4")){		// ����Ʈ ��༭. ����Ʈ ������ �޴��� ����
    		if(gubun5.equals("")) gubun5 = "4";		// �⺻ �˻� �� ���.
    %>
    <tr>
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class="title" width=10%>��ȸ����</td>
                    <td width="40%">&nbsp;
						<select name='gubun4'>
                            <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>�������</option>
                        </select>			
						&nbsp;	
						<select name='gubun5'>			    
                            <option value="1" <%if(gubun5.equals("1"))%>selected<%%>>����</option>                            
                            <option value="2" <%if(gubun5.equals("2"))%>selected<%%>>����</option>
                            <option value="3" <%if(gubun5.equals("3"))%>selected<%%>>2��</option>	
                            <option value="4" <%if(gubun5.equals("4"))%>selected<%%>>���</option>
                            <option value="5" <%if(gubun5.equals("5"))%>selected<%%>>����</option>
                            <option value="6" <%if(gubun5.equals("6"))%>selected<%%>>�Ⱓ</option>					
                        </select>		
						&nbsp;				  
                        <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
						~
						<input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text">
					</td>
                   	<td class=title width=10%>����</td>
                   	<td width=40%>&nbsp;
       		 			<select name='gubun1'>
	                      	<option value=''  <%if(gubun1.equals("")){ %>selected<%}%>>��ü </option>                      
	                      	<option value='Y' <%if(gubun1.equals("Y")){%>selected<%}%>>���� </option>
	                      	<option value='N' <%if(gubun1.equals("N")){%>selected<%}%>>���� </option>                      								  
			  				<option value='F' <%if(gubun1.equals("F")){%>selected<%}%>>������ </option>
	                    </select>&nbsp;
       					<select name='gubun3'>
                     			<option value=''  <%if(gubun3.equals("")){ %>selected<%}%>>��ü </option>
                     			<option value='6' <%if(gubun3.equals("6")){%>selected<%}%>>���� </option>
                   		</select>
       	    		</td>		  		  		    					                
                </tr>		        
               	<tr>
                  	<td class=title width=10%>�˻�����</td>
                  	<td width=40%>&nbsp;
       	    			<select name='s_kd'>
	                      	<option value='1' 	<%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
	                      	<option value='13' 	<%if(s_kd.equals("13")){%>selected<%}%>>��ǥ�� </option>
			      			<option value='19' 	<%if(s_kd.equals("19")){%>selected<%}%>>����ڹ�ȣ/�������</option>
	                      	<option value='2' 	<%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>
	                      	<option value='3' 	<%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>
	                      	<option value='5' 	<%if(s_kd.equals("5")){%>selected<%}%>>�����ȣ </option>
	                      	<option value='16' 	<%if(s_kd.equals("16")){%>selected<%}%>>����</option>			  
	                      	<option value='20' 	<%if(s_kd.equals("20")){%>selected<%}%>>�����ڵ�</option>			  					  
	                      	<option value='8' 	<%if(s_kd.equals("8")){%>selected<%}%>>���ʿ����� </option>
	                      	<option value='15' 	<%if(s_kd.equals("15")){%>selected<%}%>>�������</option>			  
	                      	<option value='10' 	<%if(s_kd.equals("10")){%>selected<%}%>>��������� </option>
	                      	<option value='11' 	<%if(s_kd.equals("11")){%>selected<%}%>>��������� </option>
	                      	<option value='12' 	<%if(s_kd.equals("12")){%>selected<%}%>>����������� </option>
                   		</select>
       					&nbsp;
       					<input type='text' name='t_wd' size='18' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
       		  		</td>
                 		<td class=title width=10%>��������</td>
                 		<td width=40%>&nbsp;
       		    		<select name='gubun2'>
                     			<option value=''>��ü</option>
	                      	<%	if(brch_size > 0)	{
	        						for (int i = 0 ; i < brch_size ; i++){
	        							Hashtable branch = (Hashtable)branches.elementAt(i);%>
	                      	<option value='<%=branch.get("BR_ID")%>' <%if(gubun2.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
	                      		<%}
	        				}%>
                   		</select>
                   	</td>		  		  
               	</tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td>
        	<a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr>
    	<td style='height: 30px;'></td>
    </tr>
    <tr>
    	<td class='line'>
    	<table border=0 cellspacing=1 width=100%>
    		<tr>
    			<td class='title title_border'>����</td>
    			<td class='title title_border'>����</td>
    			<td class='title title_border'>����ȣ</td>
    			<td class='title title_border'>�����</td>
    			<td class='title title_border'>��</td>
    		</tr>
    		<%
	    		// ����Ʈ ��� ���� ����Ʈ
	    		Vector rm_vt = a_db.getContRmList_20160204(s_kd, t_wd, andor, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt);
				int rm_vt_size = rm_vt.size();
    		%>
    		<% if(rm_vt_size > 0){ %>
	    		<% for(int i=0; i < rm_vt_size; i++){ 
	    			Hashtable ht = (Hashtable)rm_vt.elementAt(i);
	    			if(!String.valueOf(ht.get("FEE_RENT_ST")).equals("1")) continue;
	    		%>
	    		<tr>
	    			<td class='center content_border'><%=i+1%></td>
	    			<td class='center content_border'><%if(String.valueOf(ht.get("USE_YN")).equals("")){%>���<%}else if(String.valueOf(ht.get("USE_YN")).equals("Y")){%>����<%}else if(String.valueOf(ht.get("USE_YN")).equals("N")){%>����<%}%></td>
	    			<td class='center content_border'><a href="javascript:set_e_doc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>', '', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("CAR_ST")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
	    			<td class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
	    			<td class='center content_border'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></td>
	    		</tr>
    		<%} %>
   		<%} else{%>
  				<tr>
					<td class='center content_border' colspan='6' style='text-align: center;'>��ϵ� �����Ͱ� �����ϴ�</td>
				</tr>	
   		<%} %>
   	</table>
   	</td>
   </tr>
    <%} else if( document_st.equals("") ){	// ������ �˻��� ����
    %>
    <tr>
    	<td class='line'>
		    <table border="0" cellspacing="1" cellpadding='0' width=100%>
		    <tr>
		    	<td class="title" width=10%>��ȸ����</td>
		    	<td width="40%">&nbsp;
					<select name='gubun4'>
		            	<option value="1" <%if(gubun4.equals("1"))%>selected<%%>>�������</option>
		              	<option value="2" <%if(gubun4.equals("2"))%>selected<%%>>���°���</option>         
		              	<%if(ck_acar_id.equals("000029")){ %>
		              		<option value="3" <%if(gubun4.equals("3"))%>selected<%%>>�뿩������</option>
		              	<%} %>     
		            </select>
					&nbsp;
					<select name='gubun5'>
		            	<option value="1" <%if(gubun5.equals("1"))%>selected<%%>>����</option>
		              	<option value="2" <%if(gubun5.equals("2"))%>selected<%%>>����</option>
		              	<option value="3" <%if(gubun5.equals("3"))%>selected<%%>>2��</option>
		              	<option value="4" <%if(gubun5.equals("4"))%>selected<%%>>���</option>
		              	<option value="5" <%if(gubun5.equals("5"))%>selected<%%>>����</option>
		              	<option value="6" <%if(gubun5.equals("6"))%>selected<%%>>�Ⱓ</option>
		            </select>
					&nbsp;
		            <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">~<input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text">
				</td>
				<td class=title width=10%>����</td>
				<td width=40%>&nbsp;
					<select name='gubun1'>
		            	<option value=''  <%if(gubun1.equals("")){ %>selected<%}%>>��ü </option>
		              	<option value='0' <%if(gubun1.equals("0")){%>selected<%}%>>�̰� </option>
		              	<option value='Y' <%if(gubun1.equals("Y")){%>selected<%}%>>���� </option>
		              	<option value='N' <%if(gubun1.equals("N")){%>selected<%}%>>���� </option>
		              	<option value='R' <%if(gubun1.equals("R")){%>selected<%}%>>������ </option>
					    <option value='G' <%if(gubun1.equals("G")){%>selected<%}%>>GPS���� </option>
					    <option value='E' <%if(gubun1.equals("E")){%>selected<%}%>>�Ͻÿϳ�</option>
					    <option value='F' <%if(gubun1.equals("F")){%>selected<%}%>>������ </option>
					    <option value='C' <%if(gubun1.equals("C")){%>selected<%}%>>�ڻ�����</option>
					    <option value='EH' <%if(gubun1.equals("EH")){%>selected<%}%>>����/������</option>
		            </select>
		            &nbsp;
		        	<select name='gubun3'>
		              	<option value=''  <%if(gubun3.equals("")){ %>selected<%}%>>��ü </option>
		              	<option value='10' <%if(gubun3.equals("10")){%>selected<%}%>>��Ʈ </option>
		              	<option value='11' <%if(gubun3.equals("11")){%>selected<%}%>>���� </option>
		              	<option value='15' <%if(gubun3.equals("15")){%>selected<%}%>>�����뿩 </option>
		              	<option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>�Ϲݽ� </option>
		              	<option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>�⺻�� </option>
		              	<option value='3' <%if(gubun3.equals("3")){%>selected<%}%>>���� </option>
		              	<option value='4' <%if(gubun3.equals("4")){%>selected<%}%>>�縮�� </option>
		              	<option value='5' <%if(gubun3.equals("5")){%>selected<%}%>>�߰��� </option>
		              	<option value='6' <%if(gubun3.equals("6")){%>selected<%}%>>���� </option>
		              	<option value='12' <%if(gubun3.equals("12")){%>selected<%}%>>�ű� </option>
		        	   	<option value='13' <%if(gubun3.equals("13")){%>selected<%}%>>���� </option>
			            <option value='14' <%if(gubun3.equals("14")){%>selected<%}%>>���� </option>
		              	<option value='8' <%if(gubun3.equals("8")){%>selected<%}%>>�������� </option>
		              	<option value='9' <%if(gubun3.equals("9")){%>selected<%}%>>������Ʈ </option>
		            </select>
		        </td>
		     </tr>
		     <tr>
		         <td class=title width=10%>�˻�����</td>
		         <td width=40%>&nbsp;
		        	  <select name='s_kd'>
			              <option value='1' 	<%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
			              <option value='13' <%if(s_kd.equals("13")){%>selected<%}%>>��ǥ�� </option>
					      <option value='19' <%if(s_kd.equals("19")){%>selected<%}%>>����ڹ�ȣ/�������</option>
			              <option value='2' 	<%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>
			              <option value='3' 	<%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>
			              <option value='4' 	<%if(s_kd.equals("4")){%>selected<%}%>>������ȣ </option>
			              <option value='5' 	<%if(s_kd.equals("5")){%>selected<%}%>>�����ȣ </option>
			              <option value='16' <%if(s_kd.equals("16")){%>selected<%}%>>����</option>
			              <option value='20' <%if(s_kd.equals("20")){%>selected<%}%>>�����ڵ�</option>
			              <option value='8' 	<%if(s_kd.equals("8")){%>selected<%}%>>���ʿ����� </option>
			              <option value='10' <%if(s_kd.equals("10")){%>selected<%}%>>��������� </option>
			              <option value='11' <%if(s_kd.equals("11")){%>selected<%}%>>��������� </option>
				          <option value='22' <%if(s_kd.equals("22")){%>selected<%}%>>���������ݽ°������ȣ</option>
		            </select>
		        		&nbsp;
		        	<input type='text' name='t_wd' size='18' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		          </td>
		          <td class=title width=10%>��������</td>
		          <td width=40%>&nbsp;
		          		<select name='gubun2'>
		              		<option value=''>��ü</option>
				              <%if(brch_size > 0)	{
				        			for (int i = 0 ; i < brch_size ; i++){
				        			Hashtable branch = (Hashtable)branches.elementAt(i);%>
				              <option value='<%=branch.get("BR_ID")%>' <%if(gubun2.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
				              <%		}
				        			} %>
		            	</select>
					</td>
		    	</tr>
		    </table>
    	</td>
    </tr>
    <tr align="right">
        <td><a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
    	<td style='height: 30px;'></td>
    </tr>
    <tr>
    	<td class='line'>
    	<table border=0 cellspacing=1 width=100%>
    		<tr>
    			<td class='title title_border'>����</td>
    			<td class='title title_border'>����</td>
    			<td class='title title_border'>����ȣ</td>
    			<td class='title title_border'>�����<br>(�°�����)</td>
    			<td class='title title_border'>��</td>
    		</tr>
    		<%
	    		if(gubun4.equals("")) gubun4 = "1";	// ������� �˻� �⺻ ����.
	    		if(gubun5.equals("")) gubun5 = "1";	// ���� �˻� �⺻ ����.
	    		
    			// ������ ����Ʈ
	    		Vector lc_s_vt = a_db.getContList_20160614(s_kd, t_wd, andor, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt);
	    		int lc_s_vt_size = lc_s_vt.size();
	    		int count = 0;
    		%>
    		<% if(lc_s_vt_size > 0){ %>
	    		<% for(int i=0; i < lc_s_vt_size; i++){ 
	    			Hashtable ht = (Hashtable)lc_s_vt.elementAt(i);
	    			if(s_kd.equals("14") && !t_wd.equals("") && String.valueOf(ht.get("CAR_ST")).equals("����Ʈ")) continue;
	    			if(!String.valueOf(ht.get("USE_YN")).equals("Y")) continue;
	    		%>
		    		<tr>
		    			<td class='center content_border'><%=++count%></td>
		    			<td class='center content_border'>
		    				<%if(String.valueOf(ht.get("USE_YN")).equals("")){%>
			                 	<%if(String.valueOf(ht.get("SANCTION_ST")).equals("��û")){%>
			                 		<font color=red>
			                 	<%}else{%>
			                 		<font color=#000000>
			                 	<%}%>
			                     <%=ht.get("SANCTION_ST")%>
			                     </font>
			                 <%}else if(String.valueOf(ht.get("USE_YN")).equals("Y")){%>
			                 		����
			                 <%}else if(String.valueOf(ht.get("USE_YN")).equals("N")){%>
			                 		����
			                 <%}%>
		    			</td>
		    			<td class='center content_border'>
		    				<a href="javascript:set_e_doc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>', '<%if(String.valueOf(ht.get("CNG_ST")).equals("")){%><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%><%}else{%><%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%><%}else{%><%=ht.get("EXT_ST2")%><%}%><%}%>', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("CAR_ST")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a>
		    			</td>
		    			<td class='center content_border'>
		    				<%if(s_kd.equals("21")){%>
			                      <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%>
			                <%}else{%>
			                	<%if(String.valueOf(ht.get("CNG_ST")).equals("���°�") && String.valueOf(ht.get("EXT_ST2")).equals("")){%>
			                		<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%>
			                	<%}else{%>
			                        <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>
			                    <%}%>                        
			                <%}%>
		    			</td>
		    			<td class='center content_border'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></td>
		    		</tr>
	    		<%}%>
    		<%} else{%>
   				<tr>
					<td class='center content_border' colspan='6' style='text-align: center;'>��ϵ� �����Ͱ� �����ϴ�</td>
				</tr>	
    		<%} %>
    	</table>
    	</td>
    </tr>
    <%} %>
    

</table>
</form>
</body>
</html>

