<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "2";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	Vector vt = cdb.getRentEndCondAll(dt, ref_dt1, ref_dt2, gubun3, gubun4 );
	int vt_size = vt.size();
	
	long total_amt 	= 0;
	long total_amt2	= 0;
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//chrome ���� 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
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
<form name="form1" id="form1" action="" method="post" target="d_content">
<input type="hidden" name="height" id="height" value="<%=height%>">

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 330px;">
					<div style="width: 330px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>									        		    
			        		    <td width=50 class="title title_border" >����</td>
			        		    <td width=60 class="title title_border" >�˸���</td>
			            		<td width=100 class="title title_border">����ȣ</td>
			            		<td width=120 class="title title_border">��ȣ</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							<tr>
								<td width=60 class="title title_border">�뿩���</td>
								<td width=70 class="title title_border">�뿩�Ⱓ</td>
								<td width=60 class="title title_border">�������</td>								
			            		<td width=80 class="title title_border">��ళ����</td>
			            		<td width=80 class="title title_border">��ุ����</td>
			            		<td width=80 class="title title_border">������</td>
			            		<td width=100 class="title title_border">����</td>
			            		<td width=80 class="title title_border">������ȣ</td>
			            		<td width=80 class="title title_border">�����</td>
			            		<td width=80 class="title title_border">���ɸ�����</td>
			            		<td width=80 class="title title_border">���ɿ��忩��</td>
			            		<td width=60 class="title title_border">���ʿ���</td>
			            		<td width=60 class="title title_border">�������</td>		
			            		<td width=60 class="title title_border">����</td>
			            		<td width=80 class="title title_border">��������<br>(2�����̳�)</td>
			            		<td width=80 class="title title_border">��������<br>(2�����̻�)</td>
			            		<td width=70 class="title title_border">��û���ϼ�</td>
			            		<td width=100 class="title title_border">��û���뿩��</td>
			            		<td width=100 class="title title_border">�����ܰ�</td>
			            		<td width=100 class="title title_border">ä�ǹݿ���</td>
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
				<td style="width: 330px;">
					<div style="width: 330px;">
						<table class="inner_top_table left_fix">						
					<%	if(vt_size > 0){%>			            
			              <% for (int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);%>
            				<tr style="height: 27px;"> 
								<td class="center content_border" width=50>
								<a href="javascript:parent.view_memo_settle('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; title='���ä�Ǹ޸�'; return true; " ) ><%= i+1%></a></td>														 
            					<td class="center content_border" width=60><a href="javascript:parent.view_kakao_contract('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_COMP_ID")%>');" class="btn" title='�˸���'><img src=/acar/images/center/button_ntalk.gif align=absmiddle border=0></a></td>
            					<td class="center content_border" width=100><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='�������� �̵�'><%=ht.get("RENT_L_CD")%></a></td>
            					<td class="center content_border" width=120><span title="<%=ht.get("FIRM_NM")%>"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
			            	</tr>
						   <%}%>
			                <tr> 
			                    <td class="title content_border" colspan="4">�հ�</td>
			                </tr>
					 	<%} else {%>  
						   	<tr>
						        <td colspan="4" class="content_border center">��ϵ� ����Ÿ�� �����ϴ�</td>
						    </tr>
					 	<%}%>
						</table>
					</div>
				</td>
				
				<td>
					<div>
						<table class="inner_top_table table_layout">  		            		
            	    <%	if(vt_size > 0){%>	
            		  <% for (int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							
							if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){
								total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
								total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("O_1")));
							}
							%>
							<tr style="height: 27px;"> 
								<td width=60 class="center content_border"><%if(String.valueOf(ht.get("RENT_WAY")).equals("����Ʈ")){%><font color='red'><%}%><%=ht.get("RENT_WAY")%><%if(String.valueOf(ht.get("RENT_WAY")).equals("����Ʈ")){%></font><%}%></td>
								<td width=70 class="center content_border"><%=ht.get("CON_MON")%>����</td>
								<td width=60 class="center content_border"><%= Util.subData(String.valueOf(ht.get("EMP_NM")),3)%></td>								
								<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
			            		<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
			            		<td width=80 class="center content_border"><a href="javascript:parent.reg_im_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_NO")%>')" onMouseOver="window.status=''; return true" title='���ǿ��������� �̵�'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></a></td>
			            		<td width=100 class="center content_border">
			            		<%if(String.valueOf(ht.get("FUEL_KD")).equals("8")){%>
			            		<font color=red>[��]</font><span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),5) %></span>
			            		<%}else{%>
			            		<span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),6) %></span>
			            		<%}%>
			            		</td>
			            		<td width=80 class="center content_border"><a href="javascript:parent.view_car('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='�ڵ�����ϳ���'><%=ht.get("CAR_NO")%></a></td>
			            		<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
			            		<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_END_DT")))%></td>
			            		<td width=80 class="center content_border"><%=ht.get("CAR_END_YN")%></td>
				                <td width=60 class="center content_border"><%=ht.get("BUS_NM")%></td>
                				<td width=60 class="center content_border"><a href="javascript:parent.req_fee_start_act('��ุ��ó����û', '<%=ht.get("FIRM_NM")%> <%=ht.get("CAR_NO")%> : 3�� ������� ä���ܰ��ݿ�, ���ǵ�� ó���ʿ�', '<%=ht.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true" title='<%=ht.get("BUS_ID2")%> ��������ڿ��� ���Ⱓ ����� ���� ó�� ��û �޸�/�޽���/���� �߼��ϱ�'><font color=green><%=ht.get("BUS_NM2")%></font></a></td>
                				<td width=60 class="center content_border">
								<a href="javascript:parent.view_memo('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','','1','','','')" onMouseOver="window.status=''; title='�������޸�'; return true; " ) >
								<%	if(String.valueOf(ht.get("RE_BUS_NM")).equals("")){%>
								<img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0>
								<%	}else{%>
								<%=ht.get("RE_BUS_NM")%>								
								<%	}%>								
								</a>
								</td>
								<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_CONT_MM_DT")))%></td>		
								<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_CONT_MM_DT2")))%></td>		
                				<td width=70 class="right content_border">
								<%	if(String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%>
								<%		if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) > 0){%>
										<%=ht.get("DLY_DAY")%>��								
								<%		}else{%>
								<%			if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >= -10){%>
										
								<%			}%>										
								<%		}%>
								<%	}%>
								</td>
                				<td width=100 class="right content_border">
								<%	if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%>
								    	<%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%>
								<%	}else{%>
								<%		if(String.valueOf(ht.get("CLS_REG_YN")).equals("Y")){%>
								        	�������
								<%		}else{%>
								<%			if(!String.valueOf(ht.get("CALL_IN_ST")).equals("")){%>
												�����ݳ�
								<%			}%>
								<%		}%>
								<%	}%>								
								</td>
                				<td width=100 class="right content_border"><%if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%><%=Util.parseDecimal(String.valueOf(ht.get("O_1")))%><%}%></td>
                				<td width=100 class="right content_border"><%if(AddUtil.parseInt(String.valueOf(ht.get("DLY_DAY"))) >0 && String.valueOf(ht.get("CLS_REG_YN")).equals("N") && String.valueOf(ht.get("CALL_IN_ST")).equals("")){%><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("DLY_AMT")))+AddUtil.parseInt(String.valueOf(ht.get("O_1"))))%><%}%></td>																
			            	</tr>
					   <%}%>
			                <tr> 
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>			
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>		  
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>					
			                    <td class="title content_border center">&nbsp;</td>			
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>					
			                    <td class="title content_border center">&nbsp;</td>		  
			                    <td class="title content_border center">&nbsp;</td>		  
			                    <td class="title content_border center">&nbsp;</td>			
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>			
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>
			                    <td class="title content_border center">&nbsp;</td>		  
			                    <td class="title content_border right" ><%=Util.parseDecimal(total_amt)%></td>
			                    <td class="title content_border right" ><%=Util.parseDecimal(total_amt2)%></td>
			                    <td class="title content_border right" ><%=Util.parseDecimal(total_amt+total_amt2)%></td>
			                </tr>
			    <%} else {%>
					       <tr>
						        <td colspan="20" class="content_border center">&nbsp;</td>
						   </tr>
			   	<%}%>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>

</body>
</html>