<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
			
	//chrome ���� 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	Vector vt = d_db.getCarPurDocList(s_kd, t_wd, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
	int vt_size = vt.size();
	
	int count =0;
	
	String mng_mode = ""; 
	if(nm_db.getWorkAuthUser("������",user_id)){
		mng_mode = "A";
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

<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_doc_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: <%if(!gubun1.equals("0")) { %>670<%}else{%>530<%}%>px;">
					<div style="width: <%if(!gubun1.equals("0")) { %>670<%}else{%>530<%}%>px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>											        		
				        		<td width='40' class='title title_border' >����</td>
				        		<%if(!gubun1.equals("0")) { %>
								<td width='30' class='title title_border'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
								<%}%>				  					
								<td width='70' class='title title_border'>����</td>
								<%if(!gubun1.equals("0")) { %>
								<td width='110' class='title title_border'>ī���Һ�</td>
								<%}%>
						        <td width='100' class='title title_border'>����ȣ</td>
				        		<td width='80' class='title title_border'>�����</td>
						        <td width="140" class='title title_border'>��</td>
						        <td width="50" class='title title_border'>����<br>����</td>		
						        <td width="50" class='title title_border'>�뿩<br>�Ⱓ</td>
		        
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
						 	<colgroup>
				       		  <col  width='100'> <!--  rowspan -->
				       		  <col  width='100'>
				       		  
				       		  <%if(!gubun1.equals("0")) { %>
				       		  <col  width='80'>
				       		  <%} %>
				       		  <col  width='60'>
				       		  <%if(!gubun1.equals("0")) { %>
				       		  <col  width='60'><!--  colspan -->		       		  							  		       		  
							  <col  width='60'><!--  colspan -->
							  <%} %>
							  
							  <%if(!gubun1.equals("0")) { %>
							  <col  width='80'>
							  <%	if(gubun1.equals("2")) { %>
							  <col  width='80'><!--  rowspan -->
							  <%	} %>
							  <%} %>
							  
							  <%if(!gubun1.equals("2")) { %>
							  <col  width='30'> <!--  rowspan -->				       		  				       		  
				       		  <col  width='70'><!--  rowspan -->		       		  
							  <col  width='80'><!--  colspan -->
							  <%} %>
							 
							  
				       		  <col  width='90'>
				       		  <col  width='80'>
				       		  <col  width='80'>
				       		  
				       		  <col  width='100'> <!--  colspan -->
				       		  <col  width='70'><!--  colspan -->	
				       		  <col  width='150'><!--  colspan -->		       		  
							  <col  width='80'><!--  colspan -->
							  <col  width='80'><!--  colspan -->	
							  	       				  							  
							  <col  width='80'><!--  rowspan -->	 
				       		</colgroup>
				       		    	    
						    <tr>
						        <td width='100' rowspan="2" class='title title_border'>����</td>
						        <td width='100' rowspan="2" class='title title_border'>�����ȣ</td>
								<td colspan="<%if(!gubun1.equals("0")) { %>4<%}else{ %>1<%} %>" class='title title_border'>����</td>
								
								<%if(!gubun1.equals("0")) { %>
								<td width='80' rowspan="2" class='title title_border'>���޿�û��</td>
								<%	if(gubun1.equals("2")) { %>
								<td width='80' rowspan="2" class='title title_border'>�������<br>��������</td>
								<%	} %>
								<%} %>
									
								<%if(!gubun1.equals("2")) { %>					
								<td colspan="3" class='title title_border'>����</td>
								<%} %>
								
								<td colspan='3' class='title title_border'>Ź��</td>
								<td colspan="5" class='title title_border'>�������</td>								
								<td width='80' rowspan="2" class='title title_border'>�ӽÿ��ຸ���</td>
						    </tr>
						    <tr>
						        <%if(!gubun1.equals("0")) { %>
								<td width='80' class='title title_border'>�����</td>
								<%} %>
								<td width='60' class='title title_border'>�����</td>
								<%if(!gubun1.equals("0")) { %>
								<td width='60' class='title title_border'>������</td>
								<td width='60' class='title title_border'>����</td>
								<%} %>
								
								<%if(!gubun1.equals("2")) { %>
								<td width='30' class='title title_border'>��ĵ</td>
								<td width='70' class='title title_border'>��������</td>
								<td width='80'  class='title title_border'>�ʱ⼱����</td>
								<%} %>
								
								<td width='90' class='title title_border'>����</td>
								<td width='80' class='title title_border'>�����</td>
								<td width='80' class='title title_border'>�μ���</td>
								
								<td width='100' class='title title_border'>������</td>
								<td width='70' class='title title_border'>����</td>				  				  
								<td width='150' class='title title_border'>������</td>
								<td width='80' class='title title_border'>�������</td>
								<td width='80' class='title title_border'>����</td>				  
						    </tr>		     
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb" >
			<tr>
				<td style="width: <%if(!gubun1.equals("0")) { %>670<%}else{%>530<%}%>px;">
					<div style="width: <%if(!gubun1.equals("0")) { %>670<%}else{%>530<%}%>px;">
						<table class="inner_top_table left_fix">
					<%	if(vt_size > 0)	{%>
					<%
							for(int i = 0 ; i < vt_size ; i++)
							{
								Hashtable ht = (Hashtable)vt.elementAt(i);
								
								if(String.valueOf(ht.get("RENT_L_CD")).equals("K316KYPR00089")) continue;
								
								count++;
								
								String fine_doc_gov_nm = "";
								
								if(!String.valueOf(ht.get("GOV_ID")).equals("")){
									fine_doc_gov_nm = c_db.getNameById(String.valueOf(ht.get("GOV_ID")), "BANK");
								}
					%>     
				             <tr>
						        <td  width='40' class='center content_border'><a href="javascript:parent.view_memo('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ȭ����'><%=count%></a></td>
						        <%if(!gubun1.equals("0")) { %>
						        <td  width='30' class='center content_border'><%if(!String.valueOf(ht.get("DOC_STEP")).equals("") && String.valueOf(ht.get("PUR_PAY_DT")).equals("")){%><input type="checkbox" name="ch_cd" value="<%=ht.get("CAR_EST_AMT")%>/<%=ht.get("CON_EST_DT")%>/<%=ht.get("RENT_MNG_ID")%>/<%=ht.get("RENT_L_CD")%>/<%=ht.get("GOV_ID")%>/<%=ht.get("CARD_YN")%>/<%=ht.get("CAR_ST")%>" onclick="javascript:parent.select_purs_amt();"><%}else{%>-<%}%></td>
						        <%} %>
						        <td  width='70' class='center content_border'>
						            <%if(String.valueOf(ht.get("DLV_DT")).equals("") && (String.valueOf(ht.get("DOC_STEP")).equals("1")||String.valueOf(ht.get("DOC_STEP")).equals("0")) && (mng_mode.equals("A") || String.valueOf(ht.get("USER_ID1")).equals(user_id))){%>
							        <a href="javascript:parent.doc_cancel('<%=ht.get("DOC_NO")%>','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_cancel.gif"  align="absmiddle" border="0"></a>
							    	<%}else{%>
							        <span title='<%=ht.get("DELAY_CONT")%>'>
							        <%	if(String.valueOf(ht.get("BIT")).equals("���") && AddUtil.parseInt(String.valueOf(ht.get("DELAY_MON"))) > 0){%>
							        <a href="javascript:parent.reg_delay_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">���</a>
							        <%	}%>
							        <%=ht.get("BIT")%>
							        </span>
							     <%}%>
						        </td>
						        <%if(!gubun1.equals("0")) { %>
						        <td  width='110' class='center content_border'>
						            <%if(String.valueOf(ht.get("APP_DT")).equals("")){%>
						                <%if(String.valueOf(ht.get("CARD_YN")).equals("Y")){%>
						                    <%=fine_doc_gov_nm%>
						                <%}%>
						            <%}else{%>
						                <%if(String.valueOf(ht.get("CARD_YN")).equals("Y")){%><span title='<%=fine_doc_gov_nm%>'><%=AddUtil.substringbdot(fine_doc_gov_nm, 10)%></span><%}%><%=AddUtil.ChangeDate(String.valueOf(ht.get("APP_DT")),"MM/DD")%>
						            <%}%>
						        </td>
						        <%}%>
						        <td  width='100' class='center content_border'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
						        <td  width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
						        <td  width='140' class='center content_border'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("FIRM_NM")), 17)%></span></td>
						        <td  width='50' class='center content_border'><%=c_db.getNameById(String.valueOf(ht.get("BUS_ID")),"USER")%></td>	
						        <td  width='50' class='center content_border'><%=ht.get("CON_MON")%></td>				
						    </tr>
						  <%		}%>		
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
			<%
				if(vt_size > 0)	{ %>
			<%
					for(int i = 0 ; i < vt_size ; i++)
					{
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("RENT_L_CD")).equals("K316KYPR00089")) continue;
						
						String scan_cnt			= String.valueOf(ht.get("SCAN_CNT"));
						String dlv_dt	 		= String.valueOf(ht.get("DLV_DT"));
						String gi_st 			= String.valueOf(ht.get("GI_ST2"));
						String pp_st 			= String.valueOf(ht.get("PP_ST"));
						String scd_yn 			= String.valueOf(ht.get("SCD_YN"));
						String file_name1		= String.valueOf(ht.get("FILE_NAME1"));
						String file_name2		= String.valueOf(ht.get("FILE_NAME2"));
						String req_dt			= String.valueOf(ht.get("REQ_DT"));
						String sup_dt			= String.valueOf(ht.get("SUP_DT"));
						int chk_cnt = 0;
					
						if(gi_st.equals("�̰���")){ gi_st = "���Կ���"; }
						if(pp_st.equals("����") && !gi_st.equals("����")){ pp_st = "���Ǵ�ü"; }
			%>			
						    <tr>
								<td  width='100' class='center content_border'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("CAR_NM")), 12)%></span></td>				
								<td  width='100' class='center content_border'><%=ht.get("RPT_NO")%></td>
								<%if(!gubun1.equals("0")) { %>				
								<td  width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("S_USER_DT1")))%></td>
								<%}%>
								<td  width='60' class='center content_border'>
								  <!--�����-->
								  <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');" onMouseOver="window.status=''; return true">
								  	<%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
								  		<img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0">
								  	<%}else{%>
								  		<%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%>
								  	<%}%>
									</a>	
								</td>	
								<%if(!gubun1.equals("0")) { %>							
									<td  width='60' class='center content_border'>
									  <!--�������-->
									  <%if(!String.valueOf(ht.get("USER_DT1")).equals("")){%>
									  <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');" onMouseOver="window.status=''; return true">
									  		<%if(String.valueOf(ht.get("USER_DT3")).equals("")){%>
									  		<img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0">
									  		<%}else{%>
									  		<%=c_db.getNameById(String.valueOf(ht.get("USER_ID3")),"USER")%>
									  		<%}%>
									  </a>
									  <%}else{%>-<%}%>
									  </td>
									 
									<td  width='60' class='center content_border'>
									  <!--�ѹ�����-->
									  <%if(!String.valueOf(ht.get("USER_DT1")).equals("")){%>
									  <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '5', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');" onMouseOver="window.status=''; return true">
									  		<%if(String.valueOf(ht.get("USER_DT5")).equals("")){%>
									  		<img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0">
									  		<%}else{%>
									  		<%=c_db.getNameById(String.valueOf(ht.get("USER_ID5")),"USER")%>
									  		<%}%>
									  </a>
									  <%}else{%>-<%}%>
									  </td>
									<%}%>
									<%if(!gubun1.equals("0")) { %>
									<td  width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CON_EST_DT")))%></td>	
									<%	if(gubun1.equals("2")) { %>
									<td  width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%></td>
									<%	}%>									
									<%}%>
									
									<%if(!gubun1.equals("2")) { %>
									<td  width='30' class='center content_border'><a href="javascript:parent.view_scan('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%if(scan_cnt.equals("0")){%><font color=red><%}%><%=scan_cnt%><%if(gi_st.equals("0")){%></font><%}%></a><span title='�Ÿ��ֹ��� ��ĵ Ȯ��'><%=ht.get("SCAN_15_CNT")%></span></td>														
									<td  width='70' class='center content_border'><%if(gi_st.equals("���Կ���")){%><font color=red><%}%><%=gi_st%><%if(gi_st.equals("���Կ���")){%></font><%}%></td>
									<td  width='80' class='center content_border'><%if(pp_st.equals("���Ա�")||pp_st.equals("�ܾ�")){%><font color=red><%}%><span title='<%if(pp_st.equals("�ԱݿϷ�")){%>�ԱݿϷ�<%}else{%><%=Util.parseDecimal(String.valueOf(ht.get("JAN_AMT")))%>��<%}%>'><%if(pp_st.equals("�ԱݿϷ�")){%><%=ht.get("PP_PAY_DT")%><%}else{%><%=pp_st%><%}%></span><%if(pp_st.equals("���Ա�")||pp_st.equals("�ܾ�")){%></font><%}%><%=ht.get("CONT_RENT_ST_NM")%></td>
									<%}%>
									
									<td  width='90' class='center content_border'>									
									<%if(String.valueOf(ht.get("OFF_NM")).equals("") && String.valueOf(ht.get("CONS_ST")).equals("1")){%>
									���Ź��
									<%}else{%>
									        					
									    <!--�����ڵ��� ��üŹ�� �Ƿ�--> 
									    <%if(String.valueOf(ht.get("CAR_COMP_NM")).equals("�����ڵ���(��)")){%>
									    
									    <%	if(!String.valueOf(ht.get("CAR_OFF_NM")).equals("�����Ǹ���") && !String.valueOf(ht.get("CAR_OFF_NM")).equals("����������") && !String.valueOf(ht.get("CAR_OFF_NM")).equals("Ư����")){%>
									        <a href="javascript:parent.reg_cons('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
									        <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></span>
									    <%			if(String.valueOf(ht.get("OFF_NM")).equals("") && String.valueOf(ht.get("DLV_DT")).equals("")){%>			        
									            <img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle>
									    <%			}%>    
									        </a>
									    
									    <%	}else{%>
									    <%		if(String.valueOf(ht.get("USER_DT1")).equals("")){%>			        
									        
									    <%		}else{%>
									        <a href="javascript:parent.reg_cons('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
									        <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></span>
									    <%			if(String.valueOf(ht.get("CONS_ST")).equals("2") && String.valueOf(ht.get("OFF_NM")).equals("") && String.valueOf(ht.get("DLV_DT")).equals("")){%>			        
									            <img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle>
									    <%			}%>    
									        </a>
									    <%		}%>
									    <%	}%>
									    
									    <%}%>
									    
									    <!--����ڵ��� ��üŹ�� �Ƿ�--> 
									    <%if(String.valueOf(ht.get("CAR_COMP_NM")).equals("����ڵ���(��)")){%>			    
						                                <a href="javascript:parent.reg_cons('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
									        <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></span>
									    <%			if(String.valueOf(ht.get("OFF_NM")).equals("") && String.valueOf(ht.get("DLV_DT")).equals("")){%>			        
									            <img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle>
									    <%			}%>    
									        </a>			    			    
									    <%}%>
						
									    <!--����Ｚ�ڵ��� ��üŹ�� �Ƿ�--> 
									    <%if(String.valueOf(ht.get("CAR_COMP_NM")).equals("�����ڸ����ڵ���(��)")){%>                                
									        <%=ht.get("OFF_NM")%>
									    <%}%>
									    
						            <%}%>
						            
									</td>
									<td  width='80' class='center content_border'><span title='<%=ht.get("DLV_EXT")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("DLV_EXT")), 10)%></span></td>
									<td  width='80' class='center content_border'><%=ht.get("UDT_ST")%></td>
									<td  width='100' class='center content_border'><span title='<%=ht.get("CAR_COMP_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("CAR_COMP_NM")), 14)%></span></td>
									<td  width='70' class='center content_border'><%=ht.get("ONE_SELF")%></td>
									<td  width='150' class='center content_border'><span title='<%=ht.get("CAR_OFF_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("CAR_OFF_NM")), 19)%></span></td>
									<td  width='80' class='center content_border'><a href="javascript:parent.view_emp('<%=ht.get("EMP_ID")%>')";><span title='<%=ht.get("EMP_NM")%>'><%=Util.subData(String.valueOf(ht.get("EMP_NM")), 5)%></span></a></td>
									<td  width='80' class='center content_border'><!-- <a href="javascript:parent.view_con_doc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')";>����</a> --><span title='��� ������'><%=ht.get("CON_AMT")%></span></td>					
									
									<td  width='80' class='center content_border'>
										<%if(String.valueOf(ht.get("TRF_PAY_DT5")).equals("") && (String.valueOf(ht.get("CARDNO5")).equals("")||String.valueOf(ht.get("USER_DT1")).equals(""))){%>
											<a href="javascript:parent.reg_trfamt5('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
												<%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT5")))%>��
											</a>
										<%}else{%>
											<%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT5")))%>��
										<%}%>
									</td>	
						       </tr>
						 <%		}	%> 		
				      <%} else  {%>  
						       	<tr>
							       <td colspan="<%if(!gubun1.equals("0")) { %>18<%}else{%>15<%} %>" class='center content_border'>&nbsp;</td>
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

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
