<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?	"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?	"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?	"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":AddUtil.replace(request.getParameter("st_dt"),"-","");
	String end_dt 	= request.getParameter("end_dt")==null?	"":AddUtil.replace(request.getParameter("end_dt"),"-","");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//chrome ���� 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = a_db.getContList_20160614(s_kd, t_wd, andor, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt);		
	int cont_size = vt.size();
	 
  	String dot_auth = "";
  	String tax_auth = "";
  	String car_auth = "";
  	
  	if(nm_db.getWorkAuthUser("�����ڸ��",user_id)||nm_db.getWorkAuthUser("������������",user_id)){
  		dot_auth = "Y";
  	}
  	if(nm_db.getWorkAuthUser("�����Һ񼼴��",user_id)){
  		tax_auth = "Y";
  	}
  	if(nm_db.getWorkAuthUser("������������",user_id)||nm_db.getWorkAuthUser("�����ⳳ",user_id)){
  		car_auth = "Y";
  	}
  	if(nm_db.getWorkAuthUser("������",user_id)){
  		dot_auth = "Y";
  		tax_auth = "Y";
  		car_auth = "Y";
  	}
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

</head>

<body>

<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 580px;">
					<div style="width: 580px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>  
						        <td width='40' class='title title_border'>����</td>
				                <td width='40' class='title title_border'>����</td>
				                <td width="40" class='title title_border'>����</td>	
					       		<td width="50" class='title title_border'>��ĵ</td>	
					       		<td width="50" class='title title_border'>�ܱ�</td>		  		  				  	  
				                <td width='130' class='title title_border'>����ȣ</td>
				                <td width='80' class='title title_border'>�����<br>(�°���)</td>
				                <td width="150" class='title title_border'>��</td>                                     		
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
						
							<colgroup>
				       			<col width="150">
				       			<col width="100">
				       			<col width="40">
				       			<col width="100">
				       			
				       			<col width="70"> <!-- ����  rowspan -->
				       					       			
				       			<col width="80">
				       			<col width="70">
				       			<col width="80">
				       			<col width="70">
				       			<col width="70">
				       			<col width="70">
				       			<col width="50">
				       			<col width="80">
				       			<col width="80">
				       			
				       			<col width="70">		       			
				       			<col width="70">		       			
				       			<col width="70">		       			
				       		</colgroup>
												
							<tr>
			                  <td colspan="4" class='title title_border' >�ڵ���</td>		
			        		  <td rowspan="2" class='title title_border' >����</td>
			        		  <td colspan="9" class='title title_border' >���</td>
			        		  <td colspan="3" class='title title_border' >����</td>        		  
			        	    </tr>
			        		<tr>
			        		  <td width="150" class='title title_border'>����</td>
			        		  <td width="100" class='title title_border'>������ȣ</td>
			        		  <td width="40" class='title title_border'>����</td>		  
			        		  <td width="100" class='title title_border'>������ȣ</td>
			        		  
			        	      <td width='80' class='title title_border'>��������</td>
			        	      <td width='70' class='title title_border'>��౸��</td>
			        	      <td width='80' class='title title_border'>��������</td>
			        	      <td width='70' class='title title_border'>��������</td>
			        	      <td width='70' class='title title_border'>�뵵����</td>
			        	      <td width='70' class='title title_border'>��������</td>		  
			        	      <td width='50' class='title title_border'>�Ⱓ</td>
			        	      <td width='80' class='title title_border'>�뿩������</td>
			        	      <td width='80' class='title title_border'>�뿩������</td>
			        	      
			        		  <td width='70' class='title title_border'>���ʿ�����</td>        		  
			        		  <td width='70' class='title title_border'>���������</td>
			        		  <td width='70' class='title title_border'>���������</td>
			        		</tr>
	        		
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb">
			<tr>
				<td style="width: 580px;">
					<div style="width: 580px;">
						<table class="inner_top_table left_fix">  
			  
				     <%if(cont_size > 0){%>
			          <%	for(int i = 0 ; i < cont_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							String td_color = "";
							if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=' is center content_border' ";
							if(s_kd.equals("14") && !t_wd.equals("") && String.valueOf(ht.get("CAR_ST")).equals("����Ʈ")) continue;
			    				count++;
			    			%>
			                <tr style="height: 25px;"> 
			                  <td <%=td_color%> width='40' class='center content_border'><a href="javascript:parent.view_memo('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ȭ����'><%=count%><%//=i+1%></a></td>
			                  <td <%=td_color%> width='40' class='center content_border'>                      
			                          <%if(String.valueOf(ht.get("USE_YN")).equals("")){%>
			                              <%if(String.valueOf(ht.get("SANCTION_ST")).equals("��û")){%><font color=red><%}else{%><font color=#000000><%}%>
			                              <%=ht.get("SANCTION_ST")%></font>
			                          <%}else if(String.valueOf(ht.get("USE_YN")).equals("Y")){%>����<%}else if(String.valueOf(ht.get("USE_YN")).equals("N")){%>����<%}%>                      
			                  </td>
			                   <td <%=td_color%> width='40' class='center content_border'><a href="javascript:parent.view_sms_send('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='���ڹ߼�'><img src=/acar/images/center/icon_tel.gif align=absmiddle border=0></a></td>
			        		  <td <%=td_color%> width='50' class='center content_border'>        		      
			        		      <a href="javascript:parent.view_scan('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ĵ����'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
			        		  </td>		  
			        		  <td <%=td_color%> width='50' class='center content_border'><a href="javascript:parent.view_res('<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_ir.gif align=absmiddle border=0></a></td>		  		  				  
			                  <td <%=td_color%>  width='130' class='center content_border '   >
			                      <a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>', '<%=ht.get("CAR_ST")%>', '<%if(String.valueOf(ht.get("CNG_ST")).equals("")){%><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%><%}else{%><%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%><%}else{%><%=ht.get("EXT_ST2")%><%}%><%}%>','<%if(String.valueOf(ht.get("USE_YN")).equals("") && String.valueOf(ht.get("SANCTION_ST")).equals("��û")){%>��û<%}else if(String.valueOf(ht.get("USE_YN")).equals("") && !String.valueOf(ht.get("SANCTION_ST")).equals("��û")){%>�̰�<%}else{%><%}%>', '<%=ht.get("REG_STEP")%>')" onMouseOver="window.status=''; return true" title='���󼼳���'><%=ht.get("RENT_L_CD")%></a>
							  	  <%if(!String.valueOf(ht.get("USE_YN")).equals("") && dot_auth.equals("Y")){%>&nbsp;
							  	  <a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '',                      '<%=ht.get("CAR_ST")%>', '<%if(String.valueOf(ht.get("CNG_ST")).equals("")){%><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%><%}else{%><%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%><%}else{%><%=ht.get("EXT_ST2")%><%}%><%}%>','�̰�','<%=ht.get("REG_STEP")%>')" onMouseOver="window.status=''; return true">.</a>
							  	  <%}%>
							  </td>
			                  <td <%=td_color%> width='80' class='center content_border'>
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
			                  <td <%=td_color%> width='150' class='center content_border'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>')" onMouseOver="window.status=''; return true" title='����ĳ���'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></a></td>
			                </tr>
			        <%		}	%>
			         <%} else  {%>  
				           	<tr>
						           <td class='center content_border'>��ϵ� ����Ÿ�� �����ϴ�</td>
						    </tr>	              
				     <%}	%>
			            </table>
			         </div>            
				  </td>
	    		  <td>			
		     	 	<div>
						<table class="inner_top_table table_layout">   	  
	      
			       <%if(cont_size > 0){%>
			        <%	for(int i = 0 ; i < cont_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							String td_color = "";
							if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "  class='is center content_border' ";		
							if(s_kd.equals("14") && !t_wd.equals("") && String.valueOf(ht.get("CAR_ST")).equals("����Ʈ")) continue;
							
							//String ins_com_nm =  c_db.getNameById(String.valueOf(ht.get("INS_COM_ID")),"INS_COM");
							String ins_com_nm = String.valueOf(ht.get("INS_COM_NM"));
							%>
			        		<tr style="height: 25px;"> 
			        		  <td <%=td_color%> width='150' class='center content_border'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
			        		  <td <%=td_color%> width='100' class='center content_border'><a href="javascript:parent.view_car('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='�ڵ�����ϳ���'><%=ht.get("CAR_NO")%></a><%if(!String.valueOf(ht.get("CAR_NO")).equals("") && car_auth.equals("Y")){%>&nbsp;<a href="javascript:parent.view_car_exp('<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='�ڵ��������γ���'>.</a><%}%>		  
			        		  </td>					
			        		  <td <%=td_color%> width='40' class='center content_border'><%=ht.get("CAR_EXT")%></td>
			        		  <td <%=td_color%> width='100' class='center content_border'><%=ht.get("CAR_DOC_NO")%>
			        		  <%if(!String.valueOf(ht.get("CAR_NO")).equals("") && dot_auth.equals("Y")){%>&nbsp;<a href="javascript:parent.view_car_tax('<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='�ڵ��� �����Һ� ���γ���'>.</a><%}%>
			        		  </td>
			        		  <td <%=td_color%> width='70' class='center content_border'><span title='<%=ins_com_nm%>'><%=AddUtil.subData(ins_com_nm, 4)%></span></td>		  		  
			        		 
			        		  <td <%=td_color%> width='80' class='center content_border'><%=ht.get("CLS_ST")%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'>
							        <%if(String.valueOf(ht.get("CNG_ST")).equals("")){%>
								<%	if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%>
								<%	}else{%><%=ht.get("EXT_ST")%>
								<%	}%>
								<%}else{%>
								<%	if(String.valueOf(ht.get("EXT_ST2")).equals("")){%><%=ht.get("CNG_ST")%>
								<%	}else{%><%=ht.get("EXT_ST2")%>
								<%      }%>
								<%}%>
						 	 </td>		  
			        		  <td <%=td_color%> width='80' class='center content_border'><%=ht.get("BUS_ST")%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'><%=ht.get("CAR_GU")%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'><%=ht.get("CAR_ST")%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'><%=ht.get("RENT_WAY")%></td>	
			        		  <td <%=td_color%> width='50' class='center content_border'><%=ht.get("CON_MON")%><%if(String.valueOf(ht.get("EXT_ST")).equals("����")){%>(<%=ht.get("EXT_MON")%>)<%}%></td>
			        		  <td <%=td_color%> width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
			        		  <td <%=td_color%> width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'><%=AddUtil.subData(String.valueOf(ht.get("BUS_NM")), 3)%></td>   		  
			        		  <td <%=td_color%> width='70' class='center content_border'><%=AddUtil.subData(String.valueOf(ht.get("BUS_NM2")), 3)%></td>
			        		  <td <%=td_color%> width='70' class='center content_border'><%=AddUtil.subData(String.valueOf(ht.get("MNG_NM")), 3)%></td> 
			        		</tr>
			      		 <%		}	%> 		
			      <%} else  {%>  
					       	<tr>
						       <td width="1320" colspan="17" class='center content_border'>&nbsp;</td>
						     </tr>	              
				   <%}	%>
					    </table>
				  	  </div>
				    </td>
			</tr>
		</table>
	</div>
</div>		    

</form>
</body>

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=count%>';
//-->
</script>

</html>


