<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<jsp:useBean id="c_bean" class="acar.condition.ConditionBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();

	String gubun = "";
	String ref_dt1 = ""; //Util.getDate();
	String ref_dt2 = ""; //Util.getDate();
	String auth_rw = "";
	String br_id = "";
	String fn_id = "";
	String dt = "2";
	String sort = "1";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun") != null)	gubun = request.getParameter("gubun");
	if(request.getParameter("dt") != null)		dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	if(request.getParameter("br_id") != null)	br_id = request.getParameter("br_id");
	if(request.getParameter("sort") != null)	sort = request.getParameter("sort");
	
	ConditionBean c_r [] = cdb.getRegCondAll1(gubun,dt,ref_dt1,ref_dt2, br_id,fn_id, sort);
	
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

function view_client(rent_mng_id, rent_l_cd, r_st)
{
	var SUBWIN="/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;	
	window.open(SUBWIN, "View_CLIENT", "left=50, top=50, width=820, height=700, resizable=yes scrollbars=yes");
}

$(document).ready(function(){
	
	//��ü����/����
	$("#checkAll").click(function(){	        
	    if($("#checkAll").prop("checked")){	            
	        $("input[name='chkL_cd']").prop("checked",true);	            
	    }else{	            
	        $("input[name='chkL_cd']").prop("checked",false);
	    }
    })
    
    //���ݰ�꼭 ��� ��ư Ŭ��
    $("#outputTax").on("click", function(){
    	//üũ�� ���Ǹ� �Ķ���� formating
    	var param = {};
    	$("input[name='chkL_cd']:checked").each(function(){
    		param += $(this).val()+",";
    	});
    	if(param=="[object Object]"){
    		alert("���ݰ�꼭�� ����� ������ �������ּ���.");
    		return false;
    	}else{
	    	param = param.replace("[object Object]","");
	    	/* window.open('/fms2/attach/imgview_tax_print.jsp?param='+param,'popup','width=900,height=1000,top=0,left=100,scrollbars=yes'); */
	    	window.open('/acar/condition/reg_cond_sc_in_taxPrint.jsp?param='+param,'popup','width=900,height=1000,top=0,left=100,scrollbars=yes');
    	}
    	
    }); 
});

//-->
</script>

</head>
<body>

<form name='form1'  id="form1" action='' method='post' target='d_content'>
  <input type='hidden' name='height' id="height" value='<%=height%>'>
<input type="button" class="button" id="outputTax" value="���ݰ�꼭 ���">
<span style="font-size: 11px;">(�����ͷ������� ���� ~ ������ �ҿ�ɼ��ֽ��ϴ�.)</span>

 <div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 240px;">
					<div style="width: 240px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>   		            		
			            		<td width=40 class='title title_border' style="height:45">����</td>
								<td width=40 class='title title_border' style="height:45">	<input type="checkbox" id="checkAll"></td>
								<td width=60 class='title title_border' style="height:45">��ĵ</td>								
			            		<td width=100 class='title title_border'>����ȣ</td>
			            		
            				</tr>            
						</table>
					</div>
				</td>
				
				<td style="width: 2200px;">
					<div style="width: 2200px;">
						<table class="inner_top_table table_layout" style="height: 60px;">		
						   <colgroup>
				       			<col width="4%">
				       			<col width="9%">
				       			<col width="4%">
				       			<col width="11%">
				       			
				       			<col width="4%">
				       			<col width="3%">				       		
				       			<col width="4%">
				       			<col width="7%">
				       			<col width="4%">
				       			<col width="4%">
				       			
				       			<col width="6%">
				       			<col width="3%">
				       			<col width="4%">				       			
				       			<col width="3%">
				       			
				       			<col width="6%">
				       			<col width="3%">
				       			<col width="4%">
				       			<col width="6%">
				       			<col width="3%">
				       			<col width="4%">
				       			<col width="4%">				       				
							</colgroup>				
			        
			        		<tr>
			            		<td width=4% rowspan=2 class='title title_border' >�����</td>
			            		<td width=9% rowspan=2 class='title title_border' >��ȣ</td>
			            		<td width=4% rowspan=2 class='title title_border' >�����</td>
			            		<td width=11% rowspan=2 class='title title_border' >����</td>
			            		
			            		<td width=4% rowspan=2 class='title title_border' >������ȣ</td>
			            		<td width=3% rowspan=2 class='title title_border' >����</td>
			            		<td width=4% rowspan=2 class='title title_border' >�����</td>
			            		<td width=7% rowspan=2 class='title title_border' >�˻���ȿ�Ⱓ</td>
			            		<td width=4% rowspan=2 class='title title_border' >���ɸ�����</td>
			            		<td width=4% rowspan=2 class='title title_border' >������</td>
			            		
			            		<td width=6% rowspan=2 class='title title_border' >�Һα�����</td>
			            		<td width=3% rowspan=2 class='title title_border' >�뿩<br>���</td>
			            		<td width=4% rowspan=2 class='title title_border' >�뿩������</td>
			            		<td width=3% rowspan=2 class='title title_border' >�뿩<br>�Ⱓ</td>
			            		
			            		<td colspan=3 class='title title_border' >�ڵ���������</td>
			            		<td colspan=4 class='title title_border' >�������</td>			            		
			            	</tr>
			            	<tr>			            		
			            		<td width=6% class='title title_border' >������</td>
			            		<td width=3% class='title title_border' >�����</td>
			            		<td width=4% class='title title_border' >��ȭ��ȣ</td>
			            		<td width=6% class='title title_border' >������</td>
			            		<td width=3% class='title title_border' >�����</td>
			            		<td width=4% class='title title_border' >��ȭ��ȣ</td>
			            		<td width=4% class='title title_border' >�ѽ���ȣ</td>
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
				<td style="width: 240px;">
					<div style="width: 240px;">
						<table class="inner_top_table left_fix">  				
				
					<% if(c_r.length != 0){           
					    for(int i=0; i<c_r.length; i++){
					        c_bean = c_r[i];
					%>            				
							 <tr style="height: 25px;"> 
								<td class="center content_border" width=40><%= i+1 %></td>
								<td class="center content_border" width=40>
									<!-- VV ���ݰ�꼭�� ��2�ڸ�(FILE_ST)�� 10 -->
									<input type="checkbox" name="chkL_cd" value="<%=c_bean.getRent_mng_id()%><%=c_bean.getRent_l_cd()%><%= c_bean.getCar_no()%>">
								</td>
								<td class="center content_border" width=60><a href="javascript:parent.view_scan('<%=c_bean.getRent_mng_id()%>', '<%=c_bean.getRent_l_cd()%>')" onMouseOver="window.status=''; return true" title='��ĵ����'><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></td>								
            					<td class="center content_border" width=100><a href="javascript:parent.view_cont('<%=c_bean.getRent_mng_id()%>', '<%=c_bean.getRent_l_cd()%>', '', '')" onMouseOver="window.status=''; return true" title='���󼼳���'><%=c_bean.getRent_l_cd()%></a></td>
            				
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
		      
		      <td style="width: 2200px;">		
		     	 <div style="width: 2200px;">
					<table class="inner_top_table table_layout">   
            		
		<% if(c_r.length != 0){           
					    for(int i=0; i<c_r.length; i++){
      						 c_bean = c_r[i];
		%>
				    	 <tr style="height: 25px;"> 
							<td width=4% class="center content_border"><%= c_bean.getRent_dt() %></td>
		            		<td width=9% class="left content_border">&nbsp;<span title="<%= c_bean.getFirm_nm() %>"><a href="javascript:view_client('<%=c_bean.getRent_mng_id()%>','<%=c_bean.getRent_l_cd()%>','<%=c_bean.getR_st()%>')"><%= AddUtil.substringbdot(c_bean.getFirm_nm(),25) %></a></span></td>
		            		<td width=4% class="center content_border"><span title="<%= c_bean.getClient_nm() %>"><%= Util.subData(c_bean.getClient_nm(),3) %></span></td>
		            		<td width=11% class="left content_border">&nbsp;<span title="<%=c_bean.getCar_jnm()+" "+c_bean.getCar_name()%>"><%= AddUtil.substringbdot(c_bean.getCar_jnm()+" "+c_bean.getCar_name(),34) %></span></td>
		            		
		            		<td width=4% class="center content_border"><%= c_bean.getCar_no() %></td>
		            		<td width=3% class="center content_border"><%= c_bean.getCar_ext() %></td>
		            		<td width=4% class="center content_border"><%= c_bean.getInit_reg_dt() %></td>
		            		<td width=7% class="center content_border"><%= AddUtil.ChangeDate2(c_bean.getMaint_st_dt()) %>~<%= AddUtil.ChangeDate2(c_bean.getMaint_end_dt()) %></td>
		            		<td width=4% class="center content_border"><%= AddUtil.ChangeDate2(c_bean.getCar_end_dt()) %></td>
		            		<td width=4% class="center content_border"><%= c_bean.getDlv_dt() %></td>
		            		
		            		<td width=6% class="center content_border"><%=  AddUtil.substringbdot(c_bean.getBank_nm(),16) %></a></td>
			           		<td width=3% class="center content_border"><%= c_bean.getRent_way_nm() %></td>
		            		<td width=4% class="center content_border"><%= c_bean.getRent_start_dt() %></td>
		            		<td width=3% class="center content_border"><%= c_bean.getCon_mon()+"����" %></td>
		            		
		            		<td width=6% class="center content_border"><span title="<%= c_bean.getIn_car_off_nm() %>"><%= AddUtil.substringbdot(c_bean.getIn_car_off_nm(),16) %></span></td>
		            		<td width=3% class="center content_border"><span title="<%= c_bean.getIn_emp_nm() %>"><%= AddUtil.substringbdot(c_bean.getIn_emp_nm(),7) %></td>
		            		<td width=4% class="center content_border"><span title="<%= c_bean.getIn_car_off_tel() %>"><%= AddUtil.substringbdot(c_bean.getIn_car_off_tel(),13) %></span></td>
		            		<td width=6% class="center content_border"><span title="<%= c_bean.getOut_car_off_nm() %>"><%= AddUtil.substringbdot(c_bean.getOut_car_off_nm(),16)%></span></td>
		            		<td width=3% class="center content_border"><span title="<%= c_bean.getOut_emp_nm() %>"><%= AddUtil.substringbdot(c_bean.getOut_emp_nm(),7) %></span></td>
		            		<td width=4% class="center content_border"><span title="<%= c_bean.getOut_car_off_tel() %>"><%= AddUtil.substringbdot(c_bean.getOut_car_off_tel(),13) %></span></td>
		            		<td width=4% class="center content_border"><span title="<%= c_bean.getOut_car_off_fax() %>"><%= AddUtil.substringbdot(c_bean.getOut_car_off_fax(),13) %></span></td>
		            	</tr>
 <%		}	%> 		
		      <%} else  {%>  
				       	<tr>
					       <td width="2200" colspan="21" class='center content_border'>&nbsp;</td>
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