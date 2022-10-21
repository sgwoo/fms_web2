<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.insur.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":AddUtil.ChangeString(request.getParameter("start_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String first 	= request.getParameter("first")==null?"":request.getParameter("first");
	
	
	InsComDatabase inc_db = InsComDatabase .getInstance();
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//chrome ���� 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	Vector conts = new Vector();
	
	if ( !first.equals("Y")) 	conts = rs_db.getResSearchList_New(br_id, gubun1, gubun2, brch_id, start_dt, end_dt, car_comp_id, code, s_cc, s_year, s_kd, t_wd, sort_gubun, asc);
	
	int cont_size = conts.size();
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

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 460px;">
					<div style="width: 460px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
			                    <td width='40' class='title title_border'>����</td>
			                    <td width='40' class='title title_border'>����</td>
			                    <td width='40' class='title title_border'>����</td>		  
			                    <td width='80' class='title title_border'>����ġ</td>		  
			                    <td width='70' class='title title_border'>����</td>
			                    <td width='60' class='title title_border'>����</td>
			                    <td width='50' class='title title_border'>�縮��</td>
			                    <td width='80' class='title title_border'>������ȣ</td>	
							</tr>
						</table>
					</div>
				</td>
				
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">						
			        	    <tr>
					        	<td width='200' class='title title_border'>����</td>
				        	    <td width='80' class='title title_border'>���ʵ����</td>
				        	    <td width='50' class='title title_border'>��ⷮ</td>
				        	    <td width='90' class='title title_border'>Į��</td>
				        	    <td width='100' class='title title_border'>����</td>
				        	    <td width='70' class='title title_border'>����Ÿ�</td>
				        	    <td width='70' class='title title_border'>�ܱ�뿩</td>
				                <td width='80' class='title title_border'>�������</td>
				                <td width='70' class='title title_border'>�ܱ���</td>
				                <td width='80' class='title title_border'>����Ʈ���</td>
				        	    <td width='200' class='title title_border'>���û��</td>				        
				                <td width='70' class='title title_border'>��౸��</td>
				                <td width='90' class='title title_border'>��ȣ/����</td>
				                <td width='80' class='title title_border'>��������</td>					
						    	<td width='70' class='title title_border'>�����ݳ���</td>		            
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
				<td style="width: 460px;">
				  <div style="width: 460px;">
					<table class="inner_top_table left_fix">	   
								
				     <%if(cont_size > 0){%>
				<%	for(int i = 0 ; i < cont_size ; i++){
							Hashtable reserv = (Hashtable)conts.elementAt(i);
							
							int ex_count = inc_db.getCheckConfCnt(String.valueOf(reserv.get("CAR_MNG_ID")));
							if(ex_count > 0) continue;
							
							String res_st = String.valueOf(reserv.get("RES_ST"));
							String use_st = String.valueOf(reserv.get("USE_ST"));%>	
			                <tr> 
			                    <td width='40' class='center content_border'><%=i+1%></td>		  
			                    <td width='40' class='center content_border'><b><font color="#7A4F9D"><%=reserv.get("CAR_STAT")%></font></b></td>		  
			                    <td width='40' class='center content_border'><%=reserv.get("BRCH_ID")%></td>		  		  
			                    <td width='80' class='center content_border'><%if(String.valueOf(reserv.get("CAR_STAT")).equals("���")||String.valueOf(reserv.get("CAR_STAT")).equals("����")||String.valueOf(reserv.get("CAR_STAT")).equals("����")){%><span title='<%=reserv.get("PARK")%>'><%=AddUtil.subData(String.valueOf(reserv.get("PARK")), 4)%></span><font color=red><%=reserv.get("PARK_YN")%></font><%}else{%>-<%}%></td>		  		  
			                    <td width='70' class='center content_border'>					
			        		    	<%if(String.valueOf(reserv.get("PREPARE")).equals("2")){%>      <font color=red>�Ű�����</font>
			        			<%}else if(String.valueOf(reserv.get("PREPARE")).equals("3")){%><font color=red>��������</font>
			        			<%}else if(String.valueOf(reserv.get("PREPARE")).equals("4")){%><font color=red>����</font>
			        			<%}else if(String.valueOf(reserv.get("PREPARE")).equals("5")){%><font color=red>����</font>
			        			<%}else if(String.valueOf(reserv.get("PREPARE")).equals("8")){%><font color=red>����</font>
			        			<%}else{%>
								<%	if(String.valueOf(reserv.get("SITUATION")).equals("���Ȯ��")){%>    <font color=Olive>���Ȯ��</font>
								<%	}else if(String.valueOf(reserv.get("SITUATION")).equals("�����")){%><font color=Olive>�����</font>					
								<%	}else{%>&nbsp;
								<%	}%>
								<%}%>
			        		    </td>	
			                    <td width='60' class='center content_border'>
			                    <%if(String.valueOf(reserv.get("RM_ST")).equals("���")){%><font color='red'><%}%>
								<%=reserv.get("RM_ST")%>
								<%if(String.valueOf(reserv.get("RM_ST")).equals("���")){%></font><%}%>        	        
								</td>
			                    <td width='50' class='center content_border'><%=reserv.get("SH")%></td>
			                    <td width='80' class='center content_border'><a href="javascript:parent.view_car('<%=reserv.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=reserv.get("CAR_NO")%></a></td>
			                </tr>
			          <%		}	%>
			         <%} else  {%>  
				           	<tr>
						        <td  class="content_border center" >��ϵ� ����Ÿ�� �����ϴ�</td>
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
						Hashtable reserv = (Hashtable)conts.elementAt(i);
						
						int ex_count = inc_db.getCheckConfCnt(String.valueOf(reserv.get("CAR_MNG_ID")));
						if(ex_count > 0) continue;
						
						String res_st = String.valueOf(reserv.get("RES_ST"));
						String use_st = String.valueOf(reserv.get("USE_ST"));%>			
		                <tr>
		                    <td width='200' class='center content_border'>&nbsp;<span title='<%=reserv.get("CAR_NM")+" "+reserv.get("CAR_NAME")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("CAR_NM"))+" "+String.valueOf(reserv.get("CAR_NAME")), 25)%></span></td>		
		                    <td width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
		                    <td width='50' class='center content_border'><%=reserv.get("DPM")%>cc</td>
		                    <td width='90' class='center content_border'><span title='<%=reserv.get("COLO")%>'><%=AddUtil.subData(String.valueOf(reserv.get("COLO")), 6)%></span></td>
		                    <td width='100' class="center content_border"><%=reserv.get("FUEL_KD")%></td>
		                    <td width='70' class="right content_border"><%=Util.parseDecimal(String.valueOf(reserv.get("TODAY_DIST")))%></td>
		                    <td width="70" class='right content_border'><%=Util.parseDecimal(String.valueOf(reserv.get("AMT_01D")))%></td>	
		                    <td width='80' class="right content_border">
							<%if(String.valueOf(reserv.get("DAY_AMT")).equals("0") || String.valueOf(reserv.get("DAY_AMT")).equals("")){%>
							<%}else{%>
							    <%if(String.valueOf(reserv.get("CAR_USE")).equals("1")){%><font color="#000000"><%}else{%><font color="#999999"><%}%>					    
							    <span title='[�Ϲݴ���] ���뿩�� : <%=Util.parseDecimal(String.valueOf(reserv.get("FEE_AMT")))%> (vat����)'><%=Util.parseDecimal(String.valueOf(reserv.get("DAY_AMT")))%></span>
							    </font>
							<%}%>
							</td>	
		                    <td width="70" class='right content_border'><%=String.valueOf(reserv.get("SF_AMT_PER"))%>%</td>	                    
				  			<td width='80' class="right content_border"><%=Util.parseDecimal(String.valueOf(reserv.get("RM1")))%></td>								
		                    <td width='200'  class='center content_border'>&nbsp;<font color="#666666"><span title='<%=reserv.get("OPT")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("OPT")), 25)%></span></font></td>
		                    <td width='70' class='center content_border'>
		                        <%if(String.valueOf(reserv.get("CAR_STAT")).equals("���")){%>
		            			-
		                        <%}else if(!String.valueOf(reserv.get("CAR_STAT")).equals("���")){%>
		            			<font color="Maroon"><%=reserv.get("RENT_ST_NM")%></font>
		            			<%}%>
		        		    </td>				
		                    <td width='90' class='center content_border'>
		                        <%if(String.valueOf(reserv.get("CAR_STAT")).equals("���")){%>
		            			-
		                        <%}else if(!String.valueOf(reserv.get("CAR_STAT")).equals("���")){%>
		            			<font color="#808080"><span title='<%=reserv.get("CUST_NM")%>'><%=AddUtil.subData(String.valueOf(reserv.get("CUST_NM")), 6)%></span></font>
		            			<%}%>
		                    </td>
		                    <td width='80' class='center content_border'>
		                        <%if(String.valueOf(reserv.get("CAR_STAT")).equals("���")){%>
		            			-
		                        <%}else if(!String.valueOf(reserv.get("CAR_STAT")).equals("���")){%>
		            			<%=reserv.get("D_CAR_NO")%>
		            			<%}%>
		                    </td>		
		                    <td width='70' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("CALL_IN_DT")))%></td>								
		                    
		                </tr>
		    	 <%		}	%> 		
		      <%} else  {%>  
				       	<tr>
					       <td width="1400" colspan="15" class='center content_border'>&nbsp;</td>
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
//-->
</script>

</body>
</html>
