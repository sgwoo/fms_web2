<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.master_car.*" %>	
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�ڵ������� �˻� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");	

	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
				
	Vector vt = mc_db.getSsmotersComAcarExcelList(gubun3, gubun2, s_kd, st_dt, end_dt, gubun1, t_wd, gubun4);
	int vt_size = vt.size();
	
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

<script language='javascript'>
<!--
		
	
	//����ϱ�
	function DocPrint(m1_no, l_cd){
		
		var SUMWIN = "";
			
		SUMWIN="doc_car_print.jsp?m1_no="+m1_no+"&l_cd="+l_cd;	
		
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
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
  
<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width:650px;">
					<div style="width: 650px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>  
					            <td class="title title_border" width='9%'>����</td>
								<td class="title title_border" width='9%'>����<br>����<br>����</td>	  
								<td class="title title_border" width='20%'>��ü</td>	  
								<td class="title title_border" width='12%'>�������</td>	  	  
								<td class="title title_border" width='16%'>������ȣ</td>
								<td class="title title_border" width='34%'>����</td>
							</tr>
						</table>
					</div>
				</td>
				<td style="width: 2050px;">
					<div style="width: 2050px;">
						<table class="inner_top_table table_layout" style="height: 60px;">	
							<tr>					       	                	
			        	   	  <td class="title title_border" width='4%'>������</td>
							  <td class="title title_border" width='2%'>����</td>
							  <td class="title title_border" width='3%'>����</td>
							  <td class="title title_border" width='6%'>��</td>
							  <td class="title title_border" width='4%'>�繫��</td>
							  <td class="title title_border" width='12%'>�ּ�</td>
							  <td class="title title_border" width='4%'>����������</td>
							  <td class="title title_border" width='4%'>�ǿ�����</td>		
							  <td class="title title_border" width='6%'>�뿩�Ⱓ</td>			
							  <td class="title title_border" width='3%'>����<br>�����</td>		
							  <td class="title title_border" width='3%'>����<br>������</td>		
							  <td class="title title_border" width='2%'>���<br>����</td>		
							  <td class="title title_border" width='3%'>�뿩���</td>			
							  <td class="title title_border" width='2%'>����<br>�����</td>			
							  <td class="title title_border" width='4%'>����ó</td>	
							  <td class="title title_border" width='3%' >�˻���</td>	
							  <td class="title title_border" width='2%'>����</td>	
						  	  <td class="title title_border" width='3%'>�˻�ݾ�</td>				        		  
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
				<td style="width: 650px;">
					<div style="width: 650px;">
						<table class="inner_top_table left_fix">  
					 	<%if(vt_size > 0){%>  
					        <%	for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);	%>
					        <tr> 
						         <td class="center content_border" width='9%'>
						              
						         <%=i+1%></td>	
								  <td class="center content_border" width='9%'><%if( String.valueOf(ht.get("GUBUN")).equals("1") ){%>�Ƿ�<%}else if (String.valueOf(ht.get("GUBUN")).equals("2") ){%>�Ϸ�<%}else if (String.valueOf(ht.get("GUBUN")).equals("4") ){%>��Ÿ<%}else {%>���<%}%> 
								  &nbsp;<font color=red><%=ht.get("AG")%></font>
								  </td>	  
								  <td class="center content_border" width='20%'>		
								  	<span title='<%=ht.get("��ü")%>'><%=Util.subData(String.valueOf(ht.get("��ü")),7)%></span></td>		  	
								  <td class="center content_border" width='12%'><%=ht.get("�������")%></td>	  	  
								  <td class="center content_border" width='16%'>
								   <a href="javascript:parent.view_jungsan('<%=ht.get("M1_NO")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("GUBUN")%>')" onMouseOver="window.status=''; return true">
						                <%=ht.get("������ȣ")%>
						            </a></td>		  
								  <td class="center content_border" width='34%'>
								  <span title='<%=ht.get("����")%>'><%=Util.subData(String.valueOf(ht.get("����")),10)%></span></td>							 
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
			    
				<td style="width: 2050px;">		
		     	 <div style="width: 2050px;">
					<table class="inner_top_table table_layout">   	   		
		 	<%if(vt_size > 0){%>  		
	        <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
						<tr>
						  <td class="center content_border"	width='4%'><%=Util.subData(String.valueOf(ht.get("������")),4)%></td>
						  <td class="center content_border"	width='2%'><%=ht.get("����")%></td>		   
						  <td class="center content_border"	width='3%'><%=Util.subData(String.valueOf(ht.get("����")),4)%></td>
						  <td class="center content_border"	width='6%'>
						  <span title='<%=ht.get("��")%>'>
						  <%if( String.valueOf(ht.get("CAR_ST")).equals("4") ) {%> (��)<%} else { %>&nbsp;<%} %><%=Util.subData(String.valueOf(ht.get("��")),7)%></span></td>
						  <td class="center content_border"	width='4%'><%=ht.get("�繫��")%></td>
						  <td class="center content_border"	width='12%'>
						   <span title='<%=ht.get("�ּ�")%>'><%=Util.subData(String.valueOf(ht.get("�ּ�")),24)%></span></td>	
						  <td class="center content_border"	width='4%'><%=ht.get("����������")%></td>				  
						  <td class="center content_border"	width='4%'><%=ht.get("�ǿ�����")%></td>	
						  <td class="center content_border"	width='6%'><%=ht.get("�뿩�Ⱓ")%></td>
						  <td class="center content_border"	width='3%'><%=ht.get("���ʵ����")%></td>
						  <td class="center content_border"	width='3%'><%=ht.get("���ɸ�����")%></td>
						  <td class="center content_border"	width='2%'><%=ht.get("�������")%></td>
						  <td class="center content_border"	width='3%'><%=ht.get("�뿩���")%></td>	  
						  <td class="center content_border"	width='2%'><%=ht.get("���������")%></td>
						  <td class="center content_border"	width='4%'><%=ht.get("����ó")%></td>	  
						  <td class="center content_border"	width='3%'><%=ht.get("�˻���")%></td>	  
						  <td class="center content_border"	width='2%'><%=ht.get("����")%></td>	  
						  <td class="right content_border"  	width='3%'><%=AddUtil.parseDecimal(ht.get("�˻�ݾ�"))%></td>	
						</tr>
					
				<%	}	%>
			     <%} else  {%>  
				       	<tr>
					       <td  width="2050" colspan="18" class='center content_border'>&nbsp;</td>
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
</html>
