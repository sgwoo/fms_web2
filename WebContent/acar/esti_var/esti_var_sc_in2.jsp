<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	EstiCarVarBean [] ec_r = e_db.getEstiCarVarList(gubun1, gubun2, gubun3);
	int size = ec_r.length;
	
	String a_j = "";
	
	if(size>0 && gubun3.equals("")){
		for(int i=0; i<1; i++){
        		bean = ec_r[i];
        		gubun3 = bean.getA_j();
        	}  			
        }
	
	int td_size = 80;
	
	String ea_a_j  = e_db.getVar_b_dt_Chk("ea", gubun1, AddUtil.getDate(4));
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	//������ ����
	function update(a_e, a_a, seq, a_j){
		var fm = document.form1;
		fm.a_e.value = a_e;
		fm.a_a.value = a_a;
		fm.seq.value = seq;				
		fm.gubun3.value = a_j;				
		fm.target='d_content';
		fm.action = 'esti_car_var_i.jsp';
		fm.submit();
	}
	
	//������ ����
	function update2(var_nm, var_cd, d_type){
		var fm = document.form1;
		<%if(ea_a_j.equals(gubun3)){%>
		
		if(fm.auth_rw.value = '6'){
			var SUBWIN="./esti_car_var_list_i.jsp?var_cd="+var_cd+"&var_nm="+var_nm+"&d_type="+d_type+"&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>";	
			window.open(SUBWIN, "CarVar", "left=50, top=50, width=1500, height=170, scrollbars=yes");
		}else{
			alert('������ �����ϴ�.');
		}
		<%}else{%>
		alert('�ֽŹ����� ���������մϴ�.');
		<%}%>
		
	}
	

	
	/* Title ���� */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_title2.style.pixelLeft = document.body.scrollLeft ; 		
	    document.all.td_title3.style.pixelLeft = document.body.scrollLeft ; 		
	    document.all.td_title4.style.pixelLeft = document.body.scrollLeft ; 						
	}
	
	function init(){		
		setupEvents();
	}	
	
	function Esti_Car_Var_Up(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "esti_car_var_upg.jsp";
		fm.submit();		
	}	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body onLoad="javascript:init()">
<form name="form1" method="post" action="esti_car_var_i.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="a_e" value="">
  <input type="hidden" name="a_a" value="">
  <input type="hidden" name="seq" value="">
  <input type="hidden" name="cmd" value="u">
</form>  
<table border=0 cellspacing=0 cellpadding=0 width=<%=400+(td_size*size)%>>
    <tr> 
        <td id='td_title3' style='position:relative;'><span class=style2>1. �ٽɺ��� (<%=gubun3%>)</span></td>
        <td align="right">
        	<%if(nm_db.getWorkAuthUser("������",user_id)){%>
        	�� ���������� <input type="text" name="a_j" value='<%=AddUtil.ChangeDate2(AddUtil.getDate(4))%>' size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
        	<a href="javascript:Esti_Car_Var_Up();"><!-- <a href="esti_car_var_upg.jsp?gubun1=<%=gubun1%>&gubun3=<%=gubun3%>" target="_blank"> -->[���׷��̵�]</a>
        	<%}%>&nbsp;
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line width="370" id='td_title' style='position:relative;'> 
            <table border=0 cellspacing=1 width=400>
                <tr> 
                    <td class=title width="55">������ȣ</td>
                    <td class=title width="55">�����ڵ�</td>
                    <td class=title colspan="2">������</td>
                </tr>
                <tr> 
                    <td align="center" width="55">C</td>
                    <td align="center" width="55">a_c</td>
                    <td colspan="2">��з�</td>
                </tr>
                <tr> 
                    <td align="center" width="55">-</td>
                    <td align="center" width="55">m_st</td>
                    <td colspan="2">�ߺз�<br> &nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" rowspan="4" width="55">E</td>
                    <td align="center" width="55">a_e</td>
                    <td rowspan="4" width="160">�Һз�</td>
                    <td width="100" align="center">�Һз��ڵ�</td>
                </tr>
                <tr> 
                    <td align="center" width="55">-</td>
                    <td align="center" width="100">�Һз�<br> &nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" width="55">s_sd</td>
                    <td align="center" width="100">�Һз��� ����<br> &nbsp;<br> &nbsp;<br> &nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" width="55">cars</td>
                    <td align="center" width="100">�ش�����</td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" rowspan="7" width="55">(9)</td>
                    <td align="center" width="55">o_13_7</td>
                    <td rowspan="4" width="160">�ִ��ܰ���(VAT����)<br>
                    (�ʿ��� ��� ������/�𵨺��� ���� ���� �Է�)</td>
                    <td align="center" width="100"><a href="javascript:update2('�ִ��ܰ���-48����', 'o_13_7', 'f')">48����</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">o_13_6</td>
                    <td align="center" width="100"><a href="javascript:update2('�ִ��ܰ���-42����', 'o_13_6', 'f')">42����</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">o_13_5</td>
                    <td align="center" width="100"><a href="javascript:update2('�ִ��ܰ���-36����', 'o_13_5', 'f')">36����</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">o_13_4</td>
                    <td align="center" width="100"><a href="javascript:update2('�ִ��ܰ���-30����', 'o_13_4', 'f')">30����</a></td>
                </tr>
                <tr> 
                    <td align="center">o_13_3</td>
                    <td>&nbsp;</td>
                    <td align="center"><a href="javascript:update2('�ִ��ܰ���-24����', 'o_13_3', 'f')">24����</a></td>
                </tr>
                <tr> 
                    <td align="center">o_13_2</td>
                    <td>&nbsp;</td>
                    <td align="center"><a href="javascript:update2('�ִ��ܰ���-18����', 'o_13_2', 'f')">18����</a></td>
                </tr>
                <tr> 
                    <td align="center">o_13_1</td>
                    <td>&nbsp;</td>
                    <td align="center"><a href="javascript:update2('�ִ��ܰ���-12����', 'o_13_1', 'f')">12����</a></td>
                </tr>
                 -->
                <!-- 
                <tr> 
                    <td align="center" width="55">(6)</td>
                    <td align="center" width="55">g_6</td>
                    <td colspan="2"><a href="javascript:update2('�⺻�� �Ϲݰ�����/��', 'g_6', 'i')">�⺻�� 
                    �Ϲݰ�����/��</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(7)</td>
                    <td align="center" width="55">g_7</td>
                    <td colspan="2"><a href="javascript:update2('�Ϲݽ� �߰�������/��', 'g_7', 'i')">�Ϲݽ� 
                    �߰�������/��</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_11</td>
                    <td colspan="2"><a href="javascript:update2('�������������', 'o_11', 'f')">�������������</a></td>
                </tr>
                 -->
                <tr> 
                    <td align="center" width="55">(2)</td>
                    <td align="center" width="55">g_2</td>
                    <td colspan="2"><a href="javascript:update2('���� �Ƹ���ī ���պ����(����)', 'g_2', 'i')">���� 
                    �Ƹ���ī ���պ����(����)(�������ݿø�)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(sh_2)</td>
                    <td align="center" width="55">sh_g_2</td>
                    <td colspan="2"><a href="javascript:update2('���� �Ƹ���ī ���պ����(�縮��)', 'sh_g_2', 'i')">���� 
                    �Ƹ���ī ���պ����(�縮��)(�������ݿø�)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(2)c</td>
                    <td align="center" width="55">g_2_c</td>
                    <td colspan="2"><a href="javascript:update2('���� �Ϲݹ��� ������ ���պ����(����⵿����)', 'g_2_c', 'i')">���� �Ϲݹ��� ������
                    ���պ����..</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(3)</td>
                    <td align="center" width="55">g_3</td>
                    <td colspan="2"><a href="javascript:update2('���պ���� ������', 'g_3', 'f')">���պ���� ������</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(3)c</td>
                    <td align="center" width="55">g_3_c</td>
                    <td colspan="2"><a href="javascript:update2('���� ���պ���� ������', 'g_3_c', 'f')">���� ���պ���� ������</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(4)</td>
                    <td align="center" width="55">g_4</td>
                    <td colspan="2"><a href="javascript:update2('�������� ���ؿ���', 'g_4', 'f')">�������� ���ؿ���(�Ƹ���ī��å��30����)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(4)b</td>
                    <td align="center" width="55">g_4_b</td>
                    <td colspan="2"><a href="javascript:update2('�Ϲݹ��� ������ ���� �����������', 'g_4_b', 'f')">�Ϲݹ��� ������ ���� �����������</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(5)</td>
                    <td align="center" width="55">g_5</td>
                    <td colspan="2"><a href="javascript:update2('�������� ������', 'g_5', 'f')">�������� ������(�Ƹ���ī)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(5)b</td>
                    <td align="center" width="55">g_5_b</td>
                    <td colspan="2"><a href="javascript:update2('���� �������� ������', 'g_5_b', 'f')">���� �������� ������</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">k_tu</td>
                    <td colspan="2"><a href="javascript:update2('��21���̻�������谡�Խô뿩���λ�1', 'k_tu', 'f')">��21���̻��� �뿩���λ�1(�������)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��b</td>
                    <td align="center" width="55">k_tu_b</td>
                    <td colspan="2"><a href="javascript:update2('���� ��21���̻�������谡�Խô뿩���λ�1', 'k_tu_b', 'f')">���� ��21���̻��� �뿩���λ�1</a></td>
                </tr>                
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">k_pu</td>
                    <td colspan="2"><a href="javascript:update2('��21���̻�������谡�Խô뿩���λ�2', 'k_pu', 'i')">��21���̻��� �뿩���λ�2(�ݾ�)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��b</td>
                    <td align="center" width="55">k_pu_b</td>
                    <td colspan="2"><a href="javascript:update2('���� ��21���̻�������谡�Խô뿩���λ�2', 'k_pu_b', 'i')">���� ��21���̻��� �뿩���λ�2(�ݾ�)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">k_gin</td>
                    <td colspan="2"><a href="javascript:update2('����⵿����', 'k_gin', 'i')">����⵿����</a></td>
                </tr>
                
                <!--
                <tr> 
                    <td align="center" width="55">�߰���</td>
                    <td align="center" width="55">oa_d</td>
                    <td colspan="2"><a href="javascript:update2('��21���̻�������谡�Խô뿩���λ�2', 'oa_d', 'i')">��21���̻�������谡�Խô뿩���λ�2(�ݾ�)</a></td>
                </tr>
                
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_4</td>
                    <td colspan="2"><a href="javascript:update2('Ź�۷�', 'o_4', 'i')">Ź�۷�</a></td>
                </tr>                
                <tr> 
                    <td align="center" rowspan="7">�߰���</td>
                    <td align="center" width="55">oa_e_7</td>
                    <td rowspan="7" width="160">LPGŰƮ ������</td>
                    <td width="100" align="center"><a href="javascript:update2('LPGŰƮ ������-48����', 'oa_e_7', 'i')">48����</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">oa_e_6</td>
                    <td width="100" align="center"><a href="javascript:update2('LPGŰƮ ������-42����', 'oa_e_6', 'i')">42����</a></td>
                </tr>
                <tr> 
                    <td align="center">oa_e_5</td>
                    <td align="center"><a href="javascript:update2('LPGŰƮ ������-36����', 'oa_e_5', 'i')">36����</a></td>
                </tr>
                <tr> 
                    <td align="center">oa_e_4</td>
                    <td align="center"><a href="javascript:update2('LPGŰƮ ������-30����', 'oa_e_4', 'i')">30����</a></td>
                </tr>
                <tr> 
                    <td align="center">oa_e_3</td>
                    <td align="center"><a href="javascript:update2('LPGŰƮ ������-24����', 'oa_e_3', 'i')">24����</a></td>
                </tr>
                <tr> 
                    <td align="center">oa_e_2</td>
                    <td align="center"><a href="javascript:update2('LPGŰƮ ������-18����', 'oa_e_2', 'i')">18����</a></td>
                </tr>
                <tr> 
                    <td align="center">oa_e_1</td>
                    <td align="center"><a href="javascript:update2('LPGŰƮ ������-12����', 'oa_e_1', 'i')">12����</a></td>
                </tr>
                -->
            </table>
        </td>
        <td class=line width="<%=td_size*size%>"> 
            <table border=0 cellspacing=1 width=<%=td_size*size%>>
                <tr> 
                    <td class=title colspan="<%=size%>">������</td>
                </tr>
                <tr> 
                      <!--��з�-->
                      <%for(int i=0; i<size; i++){
            			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><%=bean.getA_c()%></td>
                      <%}%>
                </tr>
                <tr> 
                      <!--�ߺз�-->
                      <%for(int i=0; i<size; i++){
            			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><%=bean.getM_st()%></td>
                      <%}%>
                </tr>
                <tr> 
                      <!--�Һз��ڵ�-->
                      <%for(int i=0; i<size; i++){
            			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><%=bean.getA_e()%></td>
                      <%}%>
                </tr>
                <tr> 
                      <!--�Һз�-->
                      <%for(int i=0; i<size; i++){
            			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><!--  <a href="javascript:update('<%=bean.getA_e()%>','<%=bean.getA_a()%>','<%=bean.getSeq()%>')"></a>--><%=c_db.getNameByIdCode("0008", "", bean.getA_e())%></td>
                      <%}%>
                </tr>
                <tr> 
                      <!--�Һз�����-->
                      <%for(int i=0; i<size; i++){
            			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><%=bean.getS_sd()%></td>
                      <%}%>
                </tr>
                <tr> 
                  <!--�ش�����-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><span title='<%=bean.getCars()%>'><%=Util.subData(bean.getCars(), 3)%></span></td>
                  <%}%>
                </tr>
                <!-- 
                <tr> 
                  �ִ��ܰ���-48
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_7()%>%</td>
                  <%}%>
                </tr>
                <tr>
                  �ִ��ܰ���-42
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_6()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  �ִ��ܰ���-36
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_5()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  �ִ��ܰ���-30
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_4()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  �ִ��ܰ���-24
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_3()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  �ִ��ܰ���-18
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_2()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  �ִ��ܰ���-12
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                  <td align="right" width="<%=td_size%>"><%=bean.getO_13_1()%>%</td>
                  <%}%>
                </tr>
                 -->
                <!-- 
                <tr> 
                  �⺻�� �Ϲݰ�����/��
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getG_6())%></td>
                  <%}%>
                </tr>
                <tr> 
                  �Ϲݽ� �߰�������/��
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getG_7())%></td>
                  <%}%>
                </tr>
                <tr> 
                  �������������
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_11()%>%</td>
                  <%}%>
                </tr>
                 -->
                <tr> 
                  <!--���պ����(����)-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getG_2())%></td>
                  <%}%>
                </tr>
                <tr> 
                  <!--���պ����(�縮��)-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_g_2())%></td>
                  <%}%>
                </tr>
                <tr> 
                  <!--���� ���պ����-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getG_2_c())%></td>
                  <%}%>
                </tr>
                <tr> 
                  <!--���պ���������-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_3()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  <!--���� ���պ���������-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_3_c()%>%</td>
                  <%}%>
                </tr>                
                <tr> 
                  <!--�������� ���ط���-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_4()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  <!--�Ϲݹ��� ������ �������� ���ط���(�Ｚȭ�����)-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_4_b()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  <!--�������� ������-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_5()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  <!--���� �������� ������-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_5_b()%>%</td>
                  <%}%>
                </tr>  
                <tr> 
                  <!--21���̻��� �������-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getK_tu()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  <!--���� 21���̻��� �������-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getK_tu_b()%>%</td>
                  <%}%>
                </tr>                  
               <tr> 
                  <!--21���̻��� �ݾ�-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getK_pu())%></td>
                  <%}%>
                </tr>
                <tr> 
                  <!--���� 21���̻��� �ݾ�-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getK_pu_b())%></td>
                  <%}%>
                </tr>                        
               <tr> 
                  <!--����⵿����-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getK_gin())%></td>
                  <%}%>
                </tr>
                
                <!--              
                <tr> -->
                  <!--21������-->
                  <!--<%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_d())%></td>
                  <%}%>
                </tr>               
                <tr> 
                  Ź�۷�
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_4())%></td>
                  <%}%>
                </tr>                
                <tr> 
                  LPGŰƮ-����
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_7())%></td>
                  <%}%>
                </tr>
                <tr> 
                  LPGŰƮ-���
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_6())%></td>
                  <%}%>
                </tr>
                <tr>
                  LPGŰƮ-���
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_5())%></td>
                  <%}%>
                </tr>
                <tr>
                  LPGŰƮ-���
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_4())%></td>
                  <%}%>
                </tr>
                <tr>
                  LPGŰƮ-���
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_3())%></td>
                  <%}%>
                </tr>
                <tr>
                  LPGŰƮ-���
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_2())%></td>
                  <%}%>
                </tr>
                <tr>
                  LPGŰƮ-���
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_1())%></td>
                  <%}%>
                </tr>
                -->
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td id='td_title4' style='position:relative;'><span class=style2>2. ��Ÿ����</span></td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line width="400" id='td_title2' style='position:relative;'>
            <table border=0 cellspacing=1 width=400>
                <tr> 
                    <td class=title width="55">������ȣ</td>
                    <td class=title width="55">�����ڵ�</td>
                    <td class=title colspan="2">������</td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_2</td>
                    <td colspan="2"><a href="javascript:update2('Ư�Ҽ���', 'o_2', 'f')">Ư�Ҽ���(�ֹμ�����)</a></td>
                </tr>                 
                <tr> 
                    <td align="center" width="55">f</td>
                    <td align="center" width="55">s_f</td>
                    <td colspan="2"><a href="javascript:update2('��漼��', 's_f', 'f')">��漼��</a></td>
                </tr>
                -->
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_5</td>
                    <td colspan="2"><a href="javascript:update2('��ϼ���(������漼��)', 'o_5', 'f')">��ϼ���(������漼��)</a></td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" width="55">��c</td>
                    <td align="center" width="55">o_5_c</td>
                    <td colspan="2"><a href="javascript:update2('������漼��-����/���ֵ�', 'o_5_c', 'f')">������漼��-����/���ֵ�</a></td>
                </tr>                 
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_6</td>
                    <td rowspan="2" width="160">����ǥ�ؾ� ���� ä�Ǹ����� �� ���� ä�Ǹ��Ծ�</td>
                    <td width="100" align="center"><a href="javascript:update2('����ǥ�ؾ� ���� ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-����', 'o_6', 'if')">����</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_7</td>
                    <td width="100" align="center"><a href="javascript:update2('����ǥ�ؾ� ���� ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-���', 'o_7', 'if')">���</a></td>
                </tr>
                -->
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_14</td>
                    <td colspan="2"><a href="javascript:update2('cc���ڵ�����/��(7~9�ν�����)', 'o_14', 'i')">cc�� 
                    �ڵ�����/�� (7~9�ν� ����)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_15</td>
                    <td colspan="2"><a href="javascript:update2('�������ڵ�����/��(7~9�ν�����)', 'o_15', 'i')">������ 
                    �ڵ�����/�� (7~9�ν� ����)</a></td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_a</td>
                    <td colspan="2"><a href="javascript:update2('2004��7~9�ν�cc���ڵ�����/��', 'o_a', 'i')">2004�� 
                    7~9�ν� cc�� �ڵ�����/��</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_b</td>
                    <td colspan="2"><a href="javascript:update2('2004��7~9�ν��������ڵ�����/��', 'o_b', 'i')">2004�� 
                    7~9�ν� ������ �ڵ�����/��</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_c</td>
                    <td colspan="2"><a href="javascript:update2('2007��7~9�ν�cc���ڵ�����/��', 'o_c', 'i')">2007�� 
                    7~9�ν� cc�� �ڵ�����/��</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_d</td>
                    <td colspan="2"><a href="javascript:update2('2007��7~9�ν��������ڵ�����/��', 'o_d', 'i')">2007�� 
                    7~9�ν� ������ �ڵ�����/��</a></td>
                </tr>
                -->
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_e</td>
                    <td colspan="2"><a href="javascript:update2('1���� 7~9�ν��������ڵ�����/��', 'o_e', 'f')">1���� 
                    7~9�ν� ������ �ڵ�����/��</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_f</td>
                    <td colspan="2"><a href="javascript:update2('2���� 7~9�ν�cc���ڵ�����/��', 'o_f', 'f')">2���� 
                    7~9�ν� cc�� �ڵ�����/��</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_g</td>
                    <td colspan="2"><a href="javascript:update2('3���� 7~9�ν��������ڵ�����/��', 'o_g', 'f')">3���� 
                    7~9�ν� ������ �ڵ�����/��</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_6_1</td>
                    <td rowspan="8" width="160">[����]ä�Ǹ����� �� ä�Ǹ��Ծ�</td>
                    <td width="100" align="center"><a href="javascript:update2('ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-����', 'o_6_1', 'if')">����</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_6_2_1</td>
                    <td width="100" align="center"><a href="javascript:update2('ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-���(~20071231)', 'o_6_2_1', 'if')">���1</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_6_2_2</td>
                    <td width="100" align="center"><a href="javascript:update2('ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-���(20080101~)', 'o_6_2_2', 'if')">���2</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_6_3</td>
                    <td width="100" align="center"><a href="javascript:update2('ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-�λ�', 'o_6_3', 'if')">�λ�</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_6_4</td>
                    <td width="100" align="center"><a href="javascript:update2('ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-�泲', 'o_6_4', 'if')">�泲</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_6_5</td>
                    <td width="100" align="center"><a href="javascript:update2('ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-����', 'o_6_5', 'if')">����</a></td>
                </tr>								
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_6_7</td>
                    <td width="100" align="center"><a href="javascript:update2('ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-��õ', 'o_6_7', 'if')">��õ</a></td>
                </tr>								
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">o_6_8</td>
                    <td width="100" align="center"><a href="javascript:update2('ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-����/�뱸', 'o_6_8', 'if')">����/�뱸</a></td>
                </tr>								
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">sh_o_6_1</td>
                    <td rowspan="8" width="160">[�縮��]ä�Ǹ����� �� ä�Ǹ��Ծ�</td>
                    <td width="100" align="center"><a href="javascript:update2('[�縮��]ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-����', 'sh_o_6_1', 'if')">����</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">sh_o_6_2_1</td>
                    <td width="100" align="center"><a href="javascript:update2('[�縮��]ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-���(~20071231)', 'sh_o_6_2_1', 'if')">���1</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">sh_o_6_2_2</td>
                    <td width="100" align="center"><a href="javascript:update2('[�縮��]ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-���(20080101~)', 'sh_o_6_2_2', 'if')">���2</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">sh_o_6_3</td>
                    <td width="100" align="center"><a href="javascript:update2('[�縮��]ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-�λ�', 'sh_o_6_3', 'if')">�λ�</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">sh_o_6_4</td>
                    <td width="100" align="center"><a href="javascript:update2('[�縮��]ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-�泲', 'sh_o_6_4', 'if')">�泲</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">sh_o_6_5</td>
                    <td width="100" align="center"><a href="javascript:update2('[�縮��]ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-����', 'sh_o_6_5', 'if')">����</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">sh_o_6_7</td>
                    <td width="100" align="center"><a href="javascript:update2('[�縮��]ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-��õ', 'sh_o_6_7', 'if')">��õ</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">��</td>
                    <td align="center" width="55">sh_o_6_8</td>
                    <td width="100" align="center"><a href="javascript:update2('[�縮��]ä�Ǹ����� �� ���� ä�Ǹ��Ծ�-����/�뱸', 'sh_o_6_8', 'if')">����/�뱸</a></td>
                </tr>				
            </table>
        </td>
        <td class=line width="<%=td_size*size%>"> 
            <table border=0 cellspacing=1 width=<%=td_size*size%>>
                <tr> 
                    <td class=title colspan="<%=size%>">������</td>
                </tr>
                <!--
                <tr> 
        		Ư�Ҽ��� 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=bean.getO_2()%>%</td>
        		<%}%>
                </tr>                
                <tr> 
        		��漼�� 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=bean.getS_f()%>%</td>
        		<%}%>
                </tr>
                -->
                <tr> 
        		<!--��ϼ���(������漼��)--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=bean.getO_5()%>%</td>
        		<%}%>
                </tr>
                <!-- 
                <tr> 
        		��ϼ��� 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=bean.getO_5_c()%>%</td>
        		<%}%>
                </tr>                 
                <tr> 
        		ä�Ǹ�����/��-���� 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];
        			String o_6= String.valueOf(bean.getO_6());%>		
                    <td align="right" width="<%=td_size%>"><%if(o_6.length() >4){%><%=AddUtil.parseDecimal(bean.getO_6())%><%}else{%><%=bean.getO_6()%>%<%}%></td>
        		<%}%>
                </tr>
                <tr> 
        		ä�Ǹ�����/��-���� 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];
        			String o_7 = String.valueOf(bean.getO_7());%>		
                    <td align="right" width="<%=td_size%>"><%if(o_7.length() >4){%><%=AddUtil.parseDecimal(bean.getO_7())%><%}else{%><%=bean.getO_7()%>%<%}%></td>
        		<%}%>
                </tr>
                -->
                <tr> 
        		<!--�ڵ�����cc��--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_14())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--�ڵ�����������--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_15())%></td>
        		<%}%>
                </tr>
                <!--
                <tr> 
        		�ڵ�����cc��-2004 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_a())%></td>
        		<%}%>
                </tr>
                <tr> 
        		�ڵ�����������-2004 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_b())%></td>
        		<%}%>
                </tr>
                <tr> 
        		�ڵ�����cc��-2007 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_c())%></td>
        		<%}%>
                </tr>
                <tr> 
        		�ڵ�����������-2007 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_d())%></td>
        		<%}%>
                </tr>
                -->
                <tr> 
        		<!--�ڵ�����cc��-1����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_e())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--�ڵ�����cc��-2����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_f())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--�ڵ�����cc��-3����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_g())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_1())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_2_1())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_2_2())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_3())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_4())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_5())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_7())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_8())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[�縮��]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_1())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[�縮��]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_2_1())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[�縮��]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_2_2())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[�縮��]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_3())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[�縮��]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_4())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[�縮��]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_5())%></td>
        		<%}%>
                </tr>				
                <tr> 
        		<!--[�縮��]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_7())%></td>
        		<%}%>
                </tr>				
                <tr> 
        		<!--[�縮��]ä�Ǹ�����--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_8())%></td>
        		<%}%>
                </tr>				
            </table>
        </td>
    </tr>
</table>
</body>
</html>