<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_samt.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"4":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	
	String st_dt = s_year + s_mon + "01";
	String end_dt = s_year + s_mon + "31";
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

	String acct = request.getParameter("acct")==null?"012005":request.getParameter("acct");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//chrome ���� 
	String height = request.getParameter("height")==null?"":request.getParameter("height");

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();
	

	Vector sers = cs_db.getServNewCList(acct, gubun1, s_year, s_mon, s_kd, t_wd, sort, asc);  //û������Ʈ
	
	
	int ser_size = sers.size();
	
	long amt8_old = 0;
	long amt[] 	= new long[13];
	
	long r_labor = 0;	

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


//������� - ȸ�� �� ������ - ����Ϸ��� ��������
function view_jungsan(car_mng_id, serv_id)
{
	
	var fm = document.form1;
	
	if(confirm('��û�����·� ó���Ͻðڽ��ϱ�?'))
	{		
		fm.target = 'i_no';
		fm.action = "cus_req_dt_a.jsp?car_mng_id="+ car_mng_id + "&serv_id="+serv_id;
		fm.submit();
	}		
				
}
-->
</script>

</head>

<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 720px;">
					<div style="width: 720px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
														
							 <colgroup>
				       			<col width="10%">
				       			<col width="4%">
				       			<col width="10%">
				       			<col width="10%">
				       			<col width="20%">
				       			<col width="9%">
				       			<col width="6%">
				       			<col width="11%">
				       			
				       			<col width="5%">
				       			<col width="5%">
				       			
				       			<col width="10%">		       		  			      			
				       		</colgroup>
		       		
				             <tr> 
			                    <td width='10%'   rowspan=2  class='title title_border'>����</td>
			            	    <td width='4%'  rowspan=2 class='title title_border'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>		
			                    <td width='10%'  rowspan=2 class='title title_border'>û����</td>
			                    <td width='10%'  rowspan=2 class='title title_border'>������</td>
			                    <td width='20%'  rowspan=2 class='title title_border'>��ü</td>
			                    <td width='9%'  rowspan=2 class='title title_border'>����</td>
			                    <td width='6%'  rowspan=2 class='title title_border'>���<br>����</td>  
			                    <td width='11%'  rowspan=2 class='title title_border'>����</td>
			                    <td colspan=2  class='title title_border' >���Ǻ���</td>
			                    <td width='10%'  rowspan=2 class='title title_border'>������ȣ</td>                            
			                </tr>
			                <tr>
			                    <td width='5%' class='title title_border'>���</td>
			                    <td width='5%' class='title title_border'>���</td>  
			                </tr>
	             
						</table>
					</div>
				</td>
				
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							  <colgroup>
				       			<col width="130">
				       			<col width="60">
				       			<col width="60">
				       			<col width="60">	       			
				       			<col width="60"> 	
				       			<col width="60">	       			
				       			<col width="160">
				       			<col width="210">
				       			
				       			<col width="80">
				       			<col width="80">
				       			<col width="80">
				       			<col width="70">
				       			<col width="80">
				       			<col width="80">
				       			<col width="80"> <!-- ��å�� -->
				       				       			
				       			<col width="80">	
				       		</colgroup>
					
			                <tr>
			                    <td width='130'   rowspan=2 class='title title_border'>����</td>                  
			                   <td width='60'  rowspan=2 class='title title_border'>������</td>            
			                   <td width='60'  rowspan=2 class='title title_border'>�԰���</td>                  
			     				<td width='60'  rowspan=2 class='title title_border'>�����</td>         
			                   <td width='60'  rowspan=2 class='title title_border'>�����</td>
			                 	<td width='60'  rowspan=2 class='title title_border'>�����</td>
			        			<td width='160' rowspan=2 class='title title_border'>��</td>			  		
			                    <td width='210' rowspan=2 class='title title_border'>����</td>
			             	  	<td width='80'  class="title title_border" rowspan=2 >����ݾ�</td>            
			                    <td  class="title title_border" colspan=5 >���޳���</td>
			                    <td class="title title_border" colspan=2 >��å��</td>
			                    <td width='80'  class="title title_border" rowspan=2 >������</td>                  
			                </tr>
			                <tr>             
			                    <td width='80' class='title title_border'>����</td>   <!-- �ϴ��� ���� ���� - 20120223 -->
			                    <td width='80' class='title title_border'>��ǰ</td>    <!-- �ϴ��� ���� - 20120223 -->
			                    <td width='70' class='title title_border'>D/C</td>    <!--  d/c ���ް� -->
			                    <td width='80' class="title title_border" >���Ա�</td>
			                    <td width='80' class='title title_border'>�Ұ�</td>
			                    <td width='80' class="title title_border" >û��</td>
			                    <td width='80' class='title title_border'>������</td>
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
				<td style="width: 720px;">
					<div style="width: 720px;">
						<table class="inner_top_table left_fix">
						      
			<%	if(ser_size > 0){%>
			         <%for(int i = 0 ; i < ser_size ; i++){
							Hashtable exp = (Hashtable)sers.elementAt(i); 				
										
							%>
			                <tr style="height: 25px;"> 
			                    <td width='10%' class='center content_border'>
			                      <% if ( exp.get("JUNG_ST").equals("������") && String.valueOf(exp.get("SET_DT")).equals("")  ) { %>
			                    <a href="javascript:view_jungsan('<%=exp.get("CAR_MNG_ID")%>', '<%=exp.get("SERV_ID")%>')" onMouseOver="window.status=''; return true"> <% } %> 
			                                      
			                    <%=i+1%>
			                    <%if(exp.get("USE_YN").equals("N")){%>   	(�ؾ�) 
			                  	<%}%>
			                  	<% if ( exp.get("JUNG_ST").equals("������") && String.valueOf(exp.get("SET_DT")).equals("") ) { %> </a> <% } %>
			                    </td>
			                      <td width='4%' class='center content_border'><input type="checkbox" name="ch_cd" value="<%=exp.get("CAR_MNG_ID")%>^<%=exp.get("SERV_ID")%>^"  <% if (!String.valueOf(exp.get("SET_DT")).equals("")  ) {%>disabled <% } %> ></td>
			                      <td width='10%' class='center content_border'><%=exp.get("REQ_DT")%></td>
			                      <td width='10%' class='center content_border'>
			                      <%if(!String.valueOf(exp.get("PIC_CNT")).equals("0")){%> 
			                      &nbsp;<a href="javascript:openPopP('<%=exp.get("FILE_TYPE")%>','<%=exp.get("ATTACH_SEQ")%>');" title='����' ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
			                      <%}%>
			                     <td width='20%' class='center content_border'><%=AddUtil.subData(String.valueOf(exp.get("OFF_NM")), 8)%></td>                     
			                    <td width='9%' class='center content_border'><%=exp.get("JUNG_ST")%></td>
			                     <td width='6%' class='center content_border'><%=exp.get("ACCID_ST_NM")%></td>
			                    <td width='11%' class='center content_border'><%=exp.get("SERV_ST")%>
			                     <% if ( !String.valueOf(exp.get("J_FAULT_PER")).equals("0") )  {  %>
			                    	(�Ҽ�)
			               		 <% }%>     
			                    </td>
			                    <td width='5%' class='center content_border'><%=exp.get("OUR_FAULT_PER")%></td>
			                    <td width='5%' class='center content_border'><%=Math.abs(AddUtil.parseInt(String.valueOf(exp.get("OUR_FAULT_PER")))-100)%></td>
			                    <td width='10%' class='center content_border'><%=exp.get("CAR_NO")%></td>
			                            
			                </tr>
			       <%		}%>
			                <tr> 
			                    <td colspan="11" class='title content_border center' >�հ�&nbsp;</td>
			                </tr>
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

				<%	if(ser_size > 0){%>	
			         <%for(int i = 0 ; i < ser_size ; i++){
							Hashtable exp = (Hashtable)sers.elementAt(i); 				
								
							// ���� ��� ���Ǻ���
							 int our_fault = 0;
							 String ch_fault = "";
							 String ch_acc_st = "";
							 
							 String o_fault= cs_db.getOutFaultPer( (String)exp.get("CAR_MNG_ID"), (String)exp.get("ACCID_ID"));
							
							 StringTokenizer token2 = new StringTokenizer(o_fault,"^");
							
							 while(token2.hasMoreTokens()) {
									ch_fault = token2.nextToken().trim();	 
									ch_acc_st = token2.nextToken().trim();	 			
							 }
							 our_fault = AddUtil.parseInt (ch_fault);
							 //�Ҽ��ΰ�� �Ҽ��� ��������� 
							 if ( !String.valueOf(exp.get("J_FAULT_PER")).equals("0") )  { 
								 our_fault =  AddUtil.parseInt(String.valueOf(exp.get("J_FAULT_PER"))) ;
							 }
							 				 				 
							 long v_sup_amt = AddUtil.parseLong((String)exp.get("SUP_AMT")); //�������ް�
							
							 long v_amt = AddUtil.parseLong((String)exp.get("AMT")); //��ǰ
							 
							long v_dc_sup_amt = AddUtil.parseLong((String)exp.get("DC_SUP_AMT")); // dc ���ް�
							 
							v_dc_sup_amt  =AddUtil.l_th_rnd_long(v_dc_sup_amt);
							 	 
							 if ( exp.get("SERV_ST").equals("����")){   
							 //	if (ch_acc_st.equals("8")) {
							 //	//	v_amt = v_amt;
							 		  v_amt = v_amt * our_fault/100;
							  //  }else  {
							    //    	//	v_amt = v_amt * our_fault/100;
							      //  		v_amt = v_amt;
							   // }
							 }  
							 
							 //�ϴ��� ����   -20120223
							   v_amt  =AddUtil.l_th_rnd_long(v_amt);
							    
							 long v_labor = AddUtil.parseLong((String)exp.get("LABOR")); //����
					
							 
							if ( exp.get("SERV_ST").equals("����")){   
							// 	if (ch_acc_st.equals("8")) {
							 //	//	v_labor = v_labor;
							 		 v_labor = v_labor * our_fault/100;
							  //  }else  {
							   //   //  v_labor = v_labor * our_fault/100;
							    //    v_labor = v_labor;
							  //  }
			   				 }  
							 				   
							 long v_c_labor = AddUtil.parseLong((String)exp.get("A_LABOR")); //���� ���� ���� :õ����:dc���� 1~2õ����:10% 2~3õ����:15%, 3õ�����̻�:20%
							 
							 
							 long v_cnt =  AddUtil.parseLong((String)exp.get("CNT"));
							 
							 long v_cust_amt =  AddUtil.parseLong((String)exp.get("CUST_AMT"));
							  long v_ext_amt =  AddUtil.parseLong((String)exp.get("EXT_AMT"));
							  long v_cls_amt =  AddUtil.parseLong((String)exp.get("CLS_AMT"));
							 
							 StringTokenizer token1 = new StringTokenizer((String)exp.get("ITEM"),"^");
							 
							 String item1 = "";
							 String item2 = "";
							   
						     while(token1.hasMoreTokens()) {
							
							  	 item1 = token1.nextToken().trim();	//
							   	 item2 = token1.nextToken().trim();	//��ǰ
											
						     }	
						     
						     
						    //���� ���� ���� :õ����:dc���� 1~2õ����:10% 2~3õ����:15%, 3õ�����̻�:20%
							  
						    if  ( i == 0 ) {
						   		amt[8]   = v_c_labor + v_labor ;	
						   	}else {
						   		amt[8]  = amt[8]  + v_labor;	
						   	}
						   
						  			    
						    int c_rate = 0;
						    int vc_rate = 0;
						    int jj_amt = 0;
							int jjj_amt = 0;
							
							long s_dt = 	AddUtil.parseLong(String.valueOf(exp.get("SS_DT")));
								
														   			    
						    if ( AddUtil.parseInt(t_wd) > 1 && i == 0) {
						        amt8_old = v_c_labor;  //1ȸ���̻��� ���
						    }
						       
						    	
						//	System.out.println("c_rate=" + c_rate + "|vc_rate=" + vc_rate);
							  
						    String item3 = "";
						     
						    if (String.valueOf(exp.get("CNT")).equals("1")) {
			  			         item3 = item2;
						  	}else {
						         item3 = item2 + " �� " +  AddUtil.parseDecimal(v_cnt - 1) + " ��";		  
						  	}
						  	
						  	amt8_old =  amt[8];
						  	
						  	//���� �ϴ��� ���� - 20120223
						  	r_labor = AddUtil.l_th_rnd_long(v_labor - vc_rate);
						  	
				%>		
				           <tr style="height: 25px;"> 
				                <td width='130' class='left content_border'>&nbsp;<%=Util.subData(String.valueOf(exp.get("CAR_NM")), 10)%></td>
				                <td width='60' class='center content_border'><%=exp.get("SERV_DT")%></td>
				                <td width='60' class='center content_border'><%=exp.get("IPGODT")%></td>
			                     <td width='60' class='center content_border'><%=exp.get("CHULGODT")%></td>
			                     <td width='60' class='center content_border'><%=exp.get("REG_DT")%></td>
			                     <td width='60' class='center content_border'><%=c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER")%></td>			  
			    			  	<td width='160' class='left content_border'>&nbsp;<%=Util.subData(String.valueOf(exp.get("CLIENT_NM")), 12)%></td>
			      			    <td width='210' class='left content_border'>&nbsp;
			      			    <%if(String.valueOf(exp.get("CNT")).equals("1")){%>
			      			    <%=Util.subData(item2, 15) %>
			    			  	<%}else{%>
			    			   <%=Util.subData(item2, 10)%>&nbsp;�� <%= AddUtil.parseDecimal(v_cnt - 1)%>&nbsp;��		  
			    			  	<%}%></td>
			      			    <td width='80' class='right content_border'><%=AddUtil.parseDecimal(exp.get("SUP_AMT"))%>&nbsp;</td>      			
			                    <td width='80' class='right content_border'><%=AddUtil.parseDecimal(r_labor)%>&nbsp;</td>
			                    <td width='80' class='right content_border'><%=AddUtil.parseDecimal(v_amt)%>&nbsp;</td>
			                   <td width='70' class='right content_border'><%=AddUtil.parseDecimal(v_dc_sup_amt)%>&nbsp;</td>  
			                    <td width='80' class='right content_border'><%=AddUtil.parseDecimal(v_ext_amt)%>&nbsp;</td>
			                    <td width='80' class='right content_border'><%=AddUtil.parseDecimal(r_labor + v_amt -  v_dc_sup_amt -  v_ext_amt  )%>&nbsp;</td>
			                    <td width='80' class='right content_border'><%=AddUtil.parseDecimal(exp.get("CUST_AMT"))%>&nbsp;</td>            
			                     <td width='80' class='right content_border'><%=AddUtil.parseDecimal(exp.get("CLS_AMT"))%>&nbsp;</td>            
			                    <td width='80' class='center content_border'><%=String.valueOf(exp.get("SET_DT"))%></td>
			      
			                </tr>
			               <%	
			               
			             		amt[0]   = amt[0] + AddUtil.l_th_rnd_long( v_labor );
			             		amt[1]   = amt[1] + v_amt;
			             		amt[2]   = amt[2] + v_amt + v_labor;
			             		amt[3]   = amt[3] + vc_rate;
			             		amt[9]   = amt[9] + v_sup_amt;
			             		
			             		amt[4]   = amt[4] + r_labor;
			             		amt[5]   = amt[5] + v_amt;
			             		amt[6]   = amt[6] + r_labor + v_amt - v_dc_sup_amt  - v_ext_amt;
			             		amt[7]   = amt[7] + v_cust_amt;
			             		amt[10]   = amt[10] + v_ext_amt;
			             		amt[11]   = amt[11] + v_dc_sup_amt;
			             		
			             		amt[12]   = amt[12] + v_cls_amt;
			             	      			               
			               	}%>
			         	    <tr> 
			                    <td class='title content_border' colspan=8></td>               
			                    <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[9] )%></td>                  
			                    <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[4] )%></td>
			                    <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[5] )%></td>
			                    <td width='70' class='title content_border right'><%=Util.parseDecimal(amt[11] )%></td>
			                     <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[10] )%></td>
			                    <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[6] )%></td>
			                    <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[7] )%></td>
			                     <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[12] )%></td>
			                    <td width='80' class='title content_border right'>&nbsp;</td>             
			                </tr>
			      <%} else  {%>  
					       <tr>
						        <td width="1550" colspan="17" class='center content_border'>&nbsp;</td>
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

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
<%if(ser_size >0){%>
<script language="JavaScript">
	
</script>
<% } %>