<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	

	String dt		= request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");	

	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
 
    int kk = 0;
    
  //chrome ���� 

  //height
  	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
  	
  	int cnt = 3; //��Ȳ ��� �Ѽ�
  	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height) - 100;//��Ȳ ���μ���ŭ ���� ���������� ������
  	
	int vt_size2 = 0;
	Vector vts2 = JsDb.getCardJungDtStatINew(dt, ref_dt1, ref_dt2, br_id, dept_id, user_nm, s_yy);
		
	vt_size2 = vts2.size();	
		
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
<form action=""  id="form1"  name="form1" method="POST">
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='height' id="height" value='<%=height%>'>


<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 300px;">
					<div style="width: 300px;">
						<table class="inner_top_table left_fix" style="height: 105px;">
							<tr> 
			                    <td width="15%"  class='title title_border'>����</td>
					            <td width="29%" class='title title_border'>�μ�</td>
					            <td width="26%" class='title title_border'>����</td>
					            <td width="30%" class='title title_border'>����</td>            
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
							  <colgroup>	 
			             		<col width='8%' >
					            <col width='7%' >
					            <col width='7%' >
					            <col width='7%' >
					            <col width='9%' >
					            <col width='7%' >  <!-- �Ұ� -->          
					            <col width='8%' >           
					            <col width='7%' >
					            <col width='7%' >
					            <col width='8%' > 
					            <col width='7%' > 
					            <col width='8%' >
					            <col width='10%' >			               	
				       		</colgroup>  			       			
					       	 <tr>
					            <td colspan="7"  class="title title_border">�����ݾ�</td>
					            <td colspan="5"  class="title title_border">���ݾ�</td>
					            <td width="10%" rowspan="4"  class="title title_border" ><p>�����ܾ�<br>��`=(A)+(B)-(C)��<br> </p>	          
					            </td>
					         </tr>
					         <tr>
					           <td width="8%" rowspan="3" class="title title_border" >�����̿�<br>�ݾ�(A)</td>
					           <td width="30%" colspan="4" class="title title_border">����߰��ݾ�</td>		        
					           <td width="7%"  rowspan="3" class="title title_border">����Ȱ����</td>
					           <td width="7%" rowspan="3" class="title title_border" >�հ�</td>
					           <td width="21%" colspan="3" class="title title_border" >�����Ļ�</td>
					           <td width="7%" rowspan="3" class="title title_border">����Ȱ����</td>
					           <td width="7%" rowspan="3" class="title title_border" >�հ�</td>
					         </tr>
					     	 <tr>
					           <td colspan=3 class="title title_border">�����Ļ�</td>
					           <td width="7%" rowspan=2  class="title title_border">�Ұ�(B)</td>
					           <td width="7%" rowspan=2 class="title title_border">�߽� �� <br>Ư�ٽĺ�</td>
					           <td width="7%" rowspan=2 class="title title_border">ȸ�ĺ� & <br>Ư����</td>
					           <td width="7%" rowspan=2 class="title title_border">�Ұ�(C)</td>
					          
					         </tr>
					         <tr>
					           <td width="7%"  class="title title_border">�߽� �� <br> Ư�ٽĺ�</td>
					           <td width="7%"  class="title title_border">ȸ�ĺ�</td>
					           <td width="7%"  class="title title_border">Ư����</td>					          
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
				<td style="width: 300px;">
					<div style="width: 300px;">
						<table class="inner_top_table left_fix" >	
		<%	               
        	long gt_amt[] = new long[11];  //grand total
        	long st1_amt[] = new long[11];  //sub total
        	long st2_amt[] = new long[11];  //sub total
        	long amt[] = new long[11];  //
        	
        	long a_tot = 0; //�ܾ�	
        	long ta_tot = 0; //total ���� 
        
        	String nn= "";
        %>
        
       		 <%	for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					
					
					if (ht.get("USER_ID").equals("000177")) continue;
					
           			 nn =(String) ht.get("DEPT_NM");
         
           	 		kk += 1; 
       		  %>			
				          <tr> 
				          	<td width="15%" class='center content_border'><%= kk %></td>
				            <td width="29%" class='center content_border'><%=nn%></td>
				            <td width="26%" class='center content_border'><%=ht.get("USER_POS")%></td>
				            <td width="30%" class='center content_border'><%=ht.get("USER_NM")%></td>				                
				          </tr>
		       <%}%>
				          <tr> 
				            <td colspan="4" class='title center content_border'>�հ�</td>
				          </tr>	 
			     	  </table>
			       </div>            
				</td>
						
	 			<td>			
		     		<div>
						<table class="inner_top_table table_layout" >	   
	        <%         
          for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					
					if (ht.get("USER_ID").equals("000177")) continue;							
					
					for (int j = 1 ; j <= 10 ; j++){
						
						amt[j] = AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));   //  total
						
						gt_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  //grand total
																				
					}

					//�����̻��� ȸ�ĺ�+��Ÿ ��� ����	 
					if(ht.get("USER_ID").equals("000003")||ht.get("USER_ID").equals("000004")||ht.get("USER_ID").equals("000005")||ht.get("USER_ID").equals("000026")  ||ht.get("USER_ID").equals("000028")   ||ht.get("USER_ID").equals("000237") ){
						a_tot = amt[9]+amt[4]+amt[5] -amt[2]; 
						
					}else{
						a_tot = amt[9]+amt[8] +amt[4]+amt[5]+amt[6] -amt[1] -amt[2]-amt[3]; 
					}
					
					ta_tot += a_tot;	
										
		%>
				          <tr>		
				            <td width='8%' class='right content_border'><%if(dt.equals("5")){%><%}else{%><%=Util.parseDecimal(amt[9])%><%}%></td> <!--�̿� -->
				            <td width='7%' class='right content_border'><%=Util.parseDecimal(amt[8]+amt[10])%></td> <!-- �߽� ��Ư�ٽĺ� -->
				            <td width='7%' class='right content_border'"><%=Util.parseDecimal(amt[4])%></td> <!--ȸ�ĺ�  -->
				            <td width='7%' class='right content_border'><%=Util.parseDecimal(amt[5])%></td> <!--Ư����  -->
				            <td width='9%' class='right content_border'><%=Util.parseDecimal(amt[8]+amt[10]+amt[4]+amt[5])%></td><!-- �Ұ� -->
				            <td width='7%' class='right content_border'><%=Util.parseDecimal(amt[6])%></td><!--��Ÿ -->
				            <td width='8%' class='right content_border'><%=Util.parseDecimal(amt[9]+amt[8]+amt[10]+amt[4]+amt[5]+amt[6])%></td><!--�հ� -->
				            <td width='7%' class='right content_border'><%=Util.parseDecimal(amt[1]+amt[10])%></td>  <!-- �߽� ��Ư�ٽĺ� -->
				            <td width='7%' class='right content_border'><%=Util.parseDecimal(amt[2])%></td><!--ȸ�ĺ�  -->
				            <td width='8%' class='right content_border'><%=Util.parseDecimal(amt[1]+amt[10]+amt[2])%></td><!-- �Ұ� -->        
				            <td width='7%' class='right content_border'><%=Util.parseDecimal(amt[3])%></td>
				            <td width='8%' class='right content_border'><%=Util.parseDecimal(amt[1]+amt[10]+amt[2]+amt[3])%></td>
				            <td width='10%' class='right content_border'><%=Util.parseDecimal(a_tot)%></td>
				          </tr>
				          <%}%>
				          <tr> 
				            <td class='title right content_border' ><%if(dt.equals("5")){%><%}else{%><%=Util.parseDecimal(gt_amt[9])%><%}%></td>
				            <td class='title right content_border' ><%=Util.parseDecimal(gt_amt[8]+gt_amt[10])%></td>
				            <td class='title right content_border' ><%=Util.parseDecimal(gt_amt[4])%></td>
				            <td class='title right content_border' ><%=Util.parseDecimal(gt_amt[5])%></td>
				            <td class='title right content_border' ><%=Util.parseDecimal(gt_amt[8]+gt_amt[10]+gt_amt[4]+gt_amt[5])%></td>
				            <td class='title right content_border' ><%=Util.parseDecimal(gt_amt[6])%></td> <!--�Ұ� -->
				            <td class='title right content_border' ><%=Util.parseDecimal(gt_amt[9]+gt_amt[8]+gt_amt[10]+gt_amt[4]+gt_amt[5]+gt_amt[6])%></td>
				            <td class='title right content_border' ><%=Util.parseDecimal(gt_amt[1]+gt_amt[10])%></td>
				            <td class='title right content_border' ><%=Util.parseDecimal(gt_amt[2])%></td>
				            <td class='title right content_border' ><%=Util.parseDecimal(gt_amt[1]+gt_amt[10]+gt_amt[2])%></td>           
				            <td class='title right content_border' ><%=Util.parseDecimal(gt_amt[3])%></td>
				            <td class='title right content_border' ><%=Util.parseDecimal(gt_amt[1]+gt_amt[10]+gt_amt[2]+gt_amt[3])%></td>
				            <td class='title right content_border' ><%=Util.parseDecimal(ta_tot)%></td>
				          </tr>	  
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
