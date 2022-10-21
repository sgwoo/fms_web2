<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.car_register.*, acar.cus_reg.*"%>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page" />
<%@ include file="/acar/cookies.jsp"%>

<%
	//�ڵ������� �˻� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 		= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String s_kd 	= request.getParameter("s_kd")==null?"5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String actn 	= request.getParameter("actn")==null?"":request.getParameter("actn");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase cdb = CarRegDatabase.getInstance();
	
	RentListBean rl_r [] = cdb.getRegListAll2(br_id, st,ref_dt1,ref_dt2,gubun,gubun_nm,q_sort_nm,q_sort,s_kd,t_wd,brid, actn);  //12
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	String dpm = "";
	
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

<script language="JavaScript">
<!--
//�Ѱ���ȸ
function CarRegList(brch_id, rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt, car_name, dlv_dt)
{
	var theForm = document.CarRegDispForm;
	theForm.rent_mng_id.value 	= rent_mng_id;
	theForm.rent_l_cd.value 	= rent_l_cd;
	theForm.car_mng_id.value 	= car_mng_id;
	theForm.cmd.value 			= reg_gubun;
	theForm.action = "./register_frame.jsp";
	theForm.target = "d_content"
//	if(dlv_dt == ''){ alert('������ڰ� ������ ������� ���մϴ�.'); return; }
	theForm.submit();
}
function view_client(rent_mng_id, rent_l_cd, r_st)
{
	var SUBWIN="/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;	
	window.open(SUBWIN, "View_CLIENT", "left=50, top=50, width=720, height=600, resizable=yes, scrollbars=yes");
}
/* Title ���� */
function setupEvents()
{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
}

function moveTitle()
{
    var X ;
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}


//�˾������� ����
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}


//����ϱ�
	function DocPrint(c_id){
		
		var SUMWIN = "";
			
		SUMWIN="doc_car_print.jsp?c_id="+c_id;	
		
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
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
<form name='form1' method='post'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>								
				<td style="width: 100%;">
					<div style="width: 100%;">
						<table class="inner_top_table table_layout" style="height: 60px;">	
							<tr>
								<td width=3% class='title title_border'>����</td>
								<td width='4%' class='title title_border'><input type="checkbox"
									name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
								<!--���ɸ���2���������� ���� ����-->
								<td width=8% class='title title_border'>����ȣ</td>
								<td width=12% class='title title_border'>��ȣ</td>
								<td width=8% class='title title_border'>������ȣ</td>
								<td width=12% class='title title_border'>����</td>
								<td width=4% class='title title_border'>��ⷮ</td>
								<td width=5% class='title title_border'>�����</td>
								<td width=5% class='title title_border'>��ุ����</td>
								<td width=5% class='title title_border'>���ɸ�����</td>
								<td width=5% class='title title_border'>ó��������</td>
								<td width=6% class='title title_border'>���ɿ��忩��</td>
								<td width=6% class='title title_border'>�����Ȳ</td>						
								<td width=4% class='title title_border'>����</td>
								<td width=4% class='title title_border'>����</td> 
								<td width=5% class='title title_border'>�����</td>
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
			   <td>
				  <div>
					<table class="inner_top_table table_layout">	
						<%	if(rl_r.length != 0){ %>
						<% 		for(int i=0; i<rl_r.length; i++){
                 				rl_bean = rl_r[i];%>
						<tr>
							<td width=3% class="center content_border"><a
								href="javascript:DocPrint( '<%= rl_bean.getCar_mng_id() %>')"
								onMouseOver="window.status=''; return true"><%=i+1%></a></td> <!-- ���� -->
							<td width=4% class="center content_border">
								<%if(rl_bean.getEmp_nm().equals("Y")){%> <input type="checkbox"	name="ch_cd" value="<%=rl_bean.getCar_mng_id()%>"> <% } %>
							</td><!-- ���� -->
							<td width=8% class="center content_border"><%= rl_bean.getRent_l_cd() %></td><!-- ����ȣ -->
							<td width=12% class="center content_border"><span
								title=" <%= rl_bean.getFirm_nm() %>"><a
									href="javascript:view_client('<%=rl_bean.getRent_mng_id()%>','<%=rl_bean.getRent_l_cd()%>','<%=rl_bean.getR_st()%>')">
										<%if(rl_bean.getRrm().equals("4")){%><b>(��)&nbsp;</b>
										<%} %><%= Util.subData(rl_bean.getFirm_nm(),10) %></a></span></td><!-- ��ȣ -->
							<td width=8% class="center content_border"><a
								href="javascript:CarRegList('<%= rl_bean.getBr_id() %>','<%= rl_bean.getRent_mng_id() %>','<%= rl_bean.getRent_l_cd() %>','<%= rl_bean.getCar_mng_id() %>','<%= rl_bean.getReg_gubun() %>','<%= rl_bean.getRpt_no() %>','<%= rl_bean.getFirm_nm() %>','<%= rl_bean.getClient_nm() %>','<%= rl_bean.getImm_amt() %>','<%=rl_bean.getCar_name()%>','<%= rl_bean.getDlv_dt() %>')"
								onMouseOver="window.status=''; return true"><%= rl_bean.getCar_no() %></a></td><!-- ������ȣ -->
							<td width=12% class="center content_border "><span
								title="<%=rl_bean.getCar_nm()%> <%=rl_bean.getCar_name()%>"><%= Util.subData(rl_bean.getCar_nm()+" "+rl_bean.getCar_name(),13) %></span></td><!-- ���� -->
							<td width=4% class="center content_border"><%=cr_db.getCar_dpm(rl_bean.getCar_mng_id())%>cc</td><!-- ��ⷮ -->
							<td width=5% class="center content_border"><%= rl_bean.getInit_reg_dt() %></td><!-- ����� -->
							<td width=5% class="center content_border"><%=rl_bean.getRent_end_dt()%></td><!-- ��ุ���� -->
							<td width=5% class="center content_border"><%= AddUtil.ChangeDate2(rl_bean.getCar_end_dt()) %></td><!-- ���ɸ����� -->
							<td width=5% class="center content_border"><%= AddUtil.ChangeDate2(rl_bean.getEnd_req_dt()) %></td><!-- ó���������� -->
							<td width=6% class="center content_border"><%= rl_bean.getCar_end_yn() %></td><!-- �������忩�� -->
							<td width=6% class="center content_border">
								<%if(rl_bean.getOff_ls().equals("5")){%>���� <!--<%//}else if(rl_bean.getOff_ls().equals("1")){%>�Ű�����-->
								<%}else if(rl_bean.getOff_ls().equals("3")){%>����� <%}else if(rl_bean.getOff_ls().equals("6")){%>�Ű�
								<%}%> <%= rl_bean.getPrepare() %>
							</td><!-- �����Ȳ -->					
							<td width=4% class="center content_border"><input type="hidden"	name="vid" value="<%=rl_bean.getCar_ext()%>">
								<%=c_db.getNameByIdCode("0032", "", rl_bean.getCar_ext())%>
							</td><!-- ���� -->
						<td width=4% class="center content_border"><%=rl_bean.getBr_id() %></td><!-- ���� -->
							<td width=5% class="center content_border"><%=rl_bean.getBus_nm() %></td><!-- ����� -->
						</tr>
						<%		}%>
						<%	}%>
						<%if(rl_r.length == 0){%>
						<tr>
							<td colspan="16" class="center content_border">&nbsp;��ϵ� ����Ÿ�� �����ϴ�.</td>
						</tr>
						<%}%>
					</table>
				 </div>
			   </td>	
			</tr>
		</table>
	</div>
</div>			
</form>

<form action="./register_frame.jsp" name="CarRegDispForm" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>"> <input
		type="hidden" name="user_id" value="<%=user_id%>"> <input
		type="hidden" name="br_id" value="<%=br_id%>"> <input
		type="hidden" name="st" value="<%=st%>"> <input type="hidden"
		name="ref_dt1" value="<%=ref_dt1%>"> <input type="hidden"
		name="ref_dt2" value="<%=ref_dt2%>"> <input type="hidden"
		name="gubun" value="<%=gubun%>"> <input type="hidden"
		name="gubun_nm" value="<%=gubun_nm%>"> <input type="hidden"
		name="q_sort_nm" value="<%=q_sort_nm%>"> <input type="hidden"
		name="q_sort" value="<%=q_sort%>"> <input type="hidden"
		name="rent_mng_id" value=""> <input type="hidden"
		name="rent_l_cd" value=""> <input type="hidden"
		name="car_mng_id" value=""> <input type="hidden" name="cmd"
		value="">
</form>
	<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=rl_r.length%>
		';
	//-->
	</script>
</body>
</html>