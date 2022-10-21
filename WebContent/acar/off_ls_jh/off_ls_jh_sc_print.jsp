<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.car_register.*,acar.car_mst.*, acar.offls_pre.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_actn.Offls_actnBean"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>

<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="CarKeyBn" scope="page" class="acar.car_register.CarKeyBean"/>
<jsp:useBean id="CarMngDb" scope="page" class="acar.car_register.CarMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<jsp:useBean id="olyBean" class="acar.offls_pre.Offls_preBean" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String st = request.getParameter("st")==null?"3":request.getParameter("st");
	String gubun = request.getParameter("gubun")==null?"firm_nm":request.getParameter("gubun");	
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");	
	String q_sort_nm = request.getParameter("q_sort_nm")==null?"firm_nm":request.getParameter("q_sort_nm");	
	String q_sort = request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"00000000":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"99999999":request.getParameter("ref_dt2");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rpt_no = request.getParameter("rpt_no")==null?"":request.getParameter("rpt_no");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String cmd = "jh";
	String[] pre = request.getParameterValues("pr");
	int imm_amt = request.getParameter("imm_amt")==null?0:Util.parseInt(request.getParameter("imm_amt"));
	


%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>�ϰ����</title>
<style type=text/css>
<!--
.style1 {
	font-size: 13px;
	font-weight: bold;
}
.style2 {
	font-size: 11px;
	font-weight: bold;
}
.style4 {
	color: #C00000;
	font-size: 11px;
	font-weight: bold;
}

.style3 {
color:26329e;
font-weight: bold;
}

.style5 {
	color: #000000;
	font-size: 11px;
	
}	

-->
</style>
<link href=/include/style_opt.css rel=stylesheet type=text/css>
</head>

<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/ScriptX.cab" >
</object>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>
<%
		for(int i=0; i<pre.length; i++){
		pre[i] = pre[i].substring(0,6);
		car_mng_id = pre[i];
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
		rent_l_cd 	= String.valueOf(cont.get("RENT_L_CD"));
	detail = olaD.getActn_detail(car_mng_id);
	int a=1000;
	//��������
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(rent_mng_id, rent_l_cd);
	//������ȣ �̷�
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);
	String white = "white";	
	CarKeyBn = CarMngDb.getCarKey(car_mng_id);
	//��������
	Off_ls_pre_apprsl ap_bean = rs_db.getCarBinImg2(car_mng_id);
	//��������
	Hashtable res = rs_db.getCarInfo(car_mng_id);
	
	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	Offls_preBean olyb[] = olpD.getPre_lst(gubun, gubun_nm, brch_id);
	int totCsum = 0;
	int totFsum = 0;
	String actn_cnt = ""; //����� ���ȸ��
	String actn_id = olpD.getActn_id(car_mng_id);
	if(cmd.equals("")){
		olyBean = olpD.getPre_detail(car_mng_id); //�Ű�����������Ȳ���� ������ ��½�
	}else{
		olyBean = olpD.getPre_detail2(car_mng_id); //��ǰ��Ȳ���� ������ ��½�
	}
	String car_no = olyBean.getCar_no();
	
	seq = olaD.getAuctionPur_maxSeq(car_mng_id);
%>		
<!-- �絵���������� -->
<form action="" name="form1" method="POST" >
<table  width=100% border=0 height= border=0 cellpadding=0 cellspacing=0 align=center >
	<tr>
      <td colspan="5" align="center" height=40></td>
    </tr>
	<tr>
		<td align=center><font size='2'>(�� �������� ���������� ��49���� �ǰ� �߰��ڵ��� �Ÿž��� �㰡�� ������ �̿��� �ڴ� ����� �� ����.)</font></td>
    </tr>
</table>
<table width=100% border=1 height=90% border=0 cellpadding=0 cellspacing=0 >
    <tr>
      <td colspan="5" align="center" height=60><font size='10'><b>�ڵ����絵����������</b></font></td>
    </tr>
    <tr>
      <td colspan="1" rowspan="4" align="center" width="10%" style="font-family:dodtum; font-size:16px !important;">�ڵ�����<br>ǥ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
      <td align="center" width="15%"  height=40 style="font-family:dodtum; font-size:16px !important;">�ڵ�����Ϲ�ȣ</td>
      <td colspan="3" rowspan="1" style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_no()%></td>
    </tr>
    <tr>
      <td align="center" width="15%" height=40 style="font-family:dodtum; font-size:16px !important;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
      <td width="30%" style="font-family:dodtum; font-size:16px !important;">&nbsp;
	  <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>	 
	  </td>
      <td align="center" width="15%" height=40 style="font-family:dodtum; font-size:16px !important;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
      <td width="30%" style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=mst.getCar_nm()%> <%//=mst.getCar_name()%> </td>
    </tr>
    <tr>
      <td align="center" height=30 height=40 style="font-family:dodtum; font-size:16px !important;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;ȣ</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_num()%></td>
      <td align="center" height=30 height=40 style="font-family:dodtum; font-size:16px !important;">����������</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_form()%></td>
    </tr>
    <tr>
      <td align="center" height=40 style="font-family:dodtum; font-size:16px !important;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getCar_y_form()%></td>
      <td align="center" height=40 style="font-family:dodtum; font-size:16px !important;">��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</td>
      <td style="font-family:dodtum; font-size:16px !important;">&nbsp;<%=cr_bean.getDpm()%> cc</td>
    </tr>
    <tr>
      <td colspan="5" style="font-family:dodtum; font-size:16px !important;">
	  <p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��������<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;�� :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�Ÿž��㰡��ȣ :<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ȣ :<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ǥ�ڼ��� :<p><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ �ͻ翡 ��� �����ŵ��� ��Ź�ѿ� �־� �ͻ簡 ������ �����Ͽ�<p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ŸŰ�� ü�ᡤ�絵���� ���Ρ������ϸ��� �� �ż��ο��� ������ <p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ ���� ��ü�� ������ �� ���Ѱ� �絵���� �� ��༭�� �ͻ���<p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ �����Ͽ� ���� ������ �Ͽ� �� ���� �����ϸ�, ������ �ͻ翡 <p><p>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ �ΰ�����(�ڵ����Ÿſ�)���� �ΰ����� �̸� ������.<p><p><br>
	  
	  <center><%=AddUtil.getDate().substring(0,4)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.<p><p><br>
	  ������(�ŵ���)&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� :&nbsp;�ֽ�ȸ�� �Ƹ���ī&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)</center><p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� :&nbsp;����Ư����  �������� �ǻ���� 8, 802 (���ǵ���, �������)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ֹε�Ϲ�ȣ :&nbsp;115611-0019610&nbsp;&nbsp;<p><br>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��<p>
	  </td>
    </tr>
</table>
    
<table>
	<tr>
		<td style="font-family:dodtum; font-size:16px !important;">����ν��� 1990.  8.  27<br>���� 33150 - 9277</td>
    </tr>
</table>
</form>
<!-- �絵���������峡 -->

<!-- ��ǰ��û�� -->
<form name='form2' method='post' action=''>
<div>
<table width=754 border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td bgcolor=#FFFFFF valign=top align=center>
            <table width=714 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=15></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=428 align=center rowspan=3><img src=/acar/images/content/name.gif></td>
                                <td align=right>
                                    <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>�� ǰ ��</td>
                                            <td bgcolor=#FFFFFF align=center><%=AddUtil.getDate2(1)%> &nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp; <%=AddUtil.getDate2(2)%>&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp; <%=AddUtil.getDate2(3)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=7></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>������ȣ</td>
                                            <td bgcolor=#FFFFFF>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>��ǰ��ȣ</td>
                                            <td bgcolor=#FFFFFF>&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=12></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td bgcolor=#dddddd height=24 width=8% align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF colspan=2>&nbsp;<%=detail.getCar_jnm() + " " +detail.getCar_nm() %></td>
                                <td bgcolor=#dddddd width=6% align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF colspan=2><span class=style5>&nbsp;A/T &nbsp;M/T &nbsp;SAT &nbsp;CVT</span></td>
                                <td bgcolor=#dddddd width=7% align=center><b>��ⷮ</b></td>
                                <td bgcolor=#FFFFFF colspan=2 width=10% align=right><span class=style5><%=detail.getDpm()%>CC&nbsp;</span></td>
                                <td bgcolor=#dddddd width=8% align=center><b>�����</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5>DR&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>��Ϲ�ȣ</b></td>
                                <td bgcolor=#FFFFFF width=24%>&nbsp;<b><%=detail.getCar_no()%></b></td>
                                <td bgcolor=#dddddd width=8% align=center><b>�����ȣ</b></td>
                                <td bgcolor=#FFFFFF colspan=6>&nbsp;<b><%=detail.getCar_num()%></b></td>
                                <td bgcolor=#dddddd align=center><b>����<br>ȭ��</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5> �ν�&nbsp;<br>TON&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF>&nbsp;<b><%=detail.getCar_y_form()%></b></td>
                                <td bgcolor=#dddddd rowspan=2 align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF rowspan=2 colspan=5>
                                    <table width=100% border=0 cellspacing=0 cellpadding=3>
                                        <tr><td><span class=style5>A/C &nbsp;P/S &nbsp;ADL &nbsp;CDP &nbsp;ABS &nbsp;���׽�Ʈ &nbsp;����� <br>
                                                �˷�̴��� &nbsp;�����(�̱ۡ����) &nbsp;ECS &nbsp;AV <br>
                                                ������̼�(&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</span></td>
                                        </tr>
                                    </table>
                                <td bgcolor=#dddddd width=6% align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF colspan=2>
                                <span class=style5>&nbsp;&nbsp;
                                <%=c_db.getNameByIdCode("0039", "", detail.getFuel_kd())%>                                
                                </span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>�����</b></td>
                                <td bgcolor=#FFFFFF>&nbsp;<b><%=AddUtil.ChangeDate2(detail.getInit_reg_dt())%></b></td>
                                <td bgcolor=#dddddd align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF colspan=2><span class=style5>&nbsp;<%=detail.getColo()%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>����Ÿ�</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5>Km �� �Ҹ�&nbsp;</span></td>
                                <td bgcolor=#dddddd align=center><b>����˻�</b></td>
                                <td bgcolor=#FFFFFF colspan=2 width=15%><span class=style5>&nbsp;200 &nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;��</span></td>
                                <td bgcolor=#dddddd width=8% align=center><b>���뵵</b></td>
                                <td bgcolor=#FFFFFF colspan=3><span class=style5>�ڰ� &nbsp;���� &nbsp;��� &nbsp;��Ʈ</span></td>
                                <td bgcolor=#dddddd align=center><b>��������</b></td>
                                <td bgcolor=#FFFFFF><span class=style5>&nbsp;����&nbsp;���&nbsp;����</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=7></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td width=39% bgcolor=#FFFFFF align=center valign=top height=140>
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=2 height=22>&nbsp;<span class=style3>��ɻ�����</span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>��������ü : (��ȣ���ҷ�)</td>
                                            <td>&nbsp;</td>
                                            <td>��������ġ : (��ȣ���ҷ�)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>���ð���ġ : (��ȣ���ҷ�)</td>
                                            <td>&nbsp;</td>
                                            <td>��������ġ : (��ȣ���ҷ�)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>���Լ���ġ : (��ȣ���ҷ�)</td>
                                            <td>&nbsp;</td>
                                            <td>��������,���� : (�� �� ��)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>��������ġ : (��ȣ���ҷ�)</td>
                                            <td>&nbsp;</td>
                                            <td>��������ġ : (��ȣ���ҷ�)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>�������ġ : (��ȣ���ҷ�)</td>
                                            <td>&nbsp;</td>
                                            <td>����Ÿ���� : (��ȣ���ҷ�)</td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=12% bgcolor=#FFFFFF align=center valign=top height=140>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22 align=center><span class=style3>���������</span></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=49% bgcolor=#FFFFFF rowspan=2 align=center valign=top height=340> 
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22 colspan=2>&nbsp;<span class=style3>�ܰ�������</span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td rowspan=7><img src=/acar/images/content/cp_img.gif height=291></td>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td colspan=2 bgcolor=#dddddd align=center height=15>ǥ�ñ�ȣ</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center width=55 height=15>�����ʿ�</td>
                                                        <td bgcolor=#ffffff align=center>P</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>��ȯ�ʿ�</td>
                                                        <td bgcolor=#ffffff align=center>X</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� �� ��</td>
                                                        <td bgcolor=#ffffff align=center>U</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>��ó����</td>
                                                        <td bgcolor=#ffffff align=center>A</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� �� ��</td>
                                                        <td bgcolor=#ffffff align=center>C</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� �� ��</td>
                                                        <td bgcolor=#ffffff align=center>T</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>��������</td>
                                                        <td bgcolor=#ffffff align=center>L</td>
                                                    </tr>
                                                </table>
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 Cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>�⺻����</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� Ű (������)</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�ٷ�ġ (������)</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=3></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>�ǳ�����</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� Ʈ (�硤��)</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� �� (�硤��)</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=3></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>��ü����</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� �� ��</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table> 
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor=#FFFFFF rowspan=2 align=center valign=top height=290>
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22>&nbsp;<span class=style3>Ư�����(�Ϲ�)</span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td rowspan=2 bgcolor=#dddddd align=center>��ǰ��<br>��϶�</td>
                                                        <td colspan=2 bgcolor=#FFFFFF height=22 align=center>���ݰ�꼭 ����</td>
                                                        <td bgcolor=#FFFFFF align=center>ʦ</td>
                                                        <td bgcolor=#FFFFFF align=center>��ʦ</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=2 bgcolor=#FFFFFF height=22 align=center>����Ź�۹��</td>
                                                        <td bgcolor=#FFFFFF align=center>Ź��</td>
                                                        <td bgcolor=#FFFFFF align=center>����</td>
                                                    </tr>
                                                    <tr>
                                                        <td rowspan=2 bgcolor=#dddddd align=center>�����<br>����</td>
                                                        <td bgcolor=#FFFFFF height=22 align=center>�����Է�</td>
                                                        <td bgcolor=#FFFFFF align=center>�з���ȸ</td>
                                                        <td bgcolor=#FFFFFF align=center>��ǰ����</td>
                                                        <td bgcolor=#FFFFFF align=center>Ź�۽�û</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#FFFFFF height=38 align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;<span class=style3>���� ���û���</span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;���������� :</td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;����&nbsp;��&nbsp;�� :&nbsp;&nbsp;<%=detail.getP_car_off_nm()%></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;��ī������ :&nbsp;&nbsp;<%=detail.getP_emp_nm()%></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� :
                                            <!--
											<%// if ( detail.getP_emp_id().equals("011815")) {%>D000137
                                            <%//} else {%>D000328
                                            <%//} %>
											-->
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;���ֹι�ȣ :</td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;����������ȣ :&nbsp;&nbsp;<%=detail.getP_rpt_no()%></td>
                                        </tr>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                    </table>
                                </td>
                                <td bgcolor=#FFFFFF align=center height=190 valign=top>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td height=22 align=center><span class=style3>Ư�����<br>(��������)</span></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor=#FFFFFF align=center height=90><span class=style3>�޸��</span></td>
                                <td bgcolor=#FFFFFF>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=7></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td bgcolor=#FFFFFF align=center>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=48% align=center valign=top>
                                                <table width=96% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=22>&nbsp;<span class=style3>��ǰ������ (917)</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=18% rowspan=2 align=center bgcolor=#dddddd>�ֹι�ȣ</td>
                                                                    <td bgcolor=#ffffff rowspan=2 align=center>115611 - 0019610</td>
                                                                    <td width=18% align=center bgcolor=#dddddd height=25>����</td>
                                                                    <td bgcolor=#ffffff align=center>(��)�Ƹ���ī</td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd height=25>��ȭ��ȣ</td>
                                                                    <td bgcolor=#ffffff align=center>02-392-4243</td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd height=32>�� ��</td>
                                                                    <td bgcolor=#ffffff colspan=3>&nbsp;����� �������� ���ǵ��� 17-3 ��ȯ��� 802ȣ</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd><font color=c00000><b>�����</b></font></td>
                                                                    <td bgcolor=#ffffff height=30 align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=9% align=center><b>,</b></td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=12% align=center>����</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd><font color=c00000><b>���۰�</b></font></td>
                                                                    <td bgcolor=#ffffff height=30 align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=9% align=center><b>,</b></td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=12% align=center>����</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd>�� ��<br>�� ��</td>
                                                                    <td bgcolor=#ffffff height=60 align=center>
                                                                        <table width=95% border=0 cellspacing=0 cellpadding=0>
                                                                            <tr>
                                                                                <td height=25>������ ( �Ƹ���ī )  &nbsp;&nbsp;�ŷ����� ( ���� )</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=25>���¹�ȣ ( 140 - 004 - 023871 )</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#ffffff>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��<br>Ȯ�μ���</td>
                                                                    <td bgcolor=#ffffff>
                                                                        <table width=100% border=0 cellpadding=3 cellspacing=0>
                                                                            <tr>
                                                                                <td valign=top height=44 align=center><font style="font-size:5pt">��⳻���� Ʋ�������� Ȯ���ϸ� ���ǻ��׿� �����Ͽ� �����մϴ�.</font></td>
                                                                                <td align=right align=right><b>(��)</b></td>
                                                                             </tr>
                                                                         </table>
                                                                     </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#ffffff>�� �� ��<br>Ȯ�μ���</td>
                                                                    <td bgcolor=#ffffff>
                                                                        <table width=100% border=0 cellpadding=3 cellspacing=0>
                                                                            <tr>
                                                                                <td valign=top  height=44 align=center valign=top><font style="font-size:5pt">��⳻���� Ʋ�������� Ȯ���ϸ� ���ǻ��׿� �����Ͽ� �����մϴ�.</font></td>
                                                                                <td align=right><b>(��)</b></td>
                                                                             </tr>
                                                                         </table>
                                                                     </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=52%>
                                                <table width=99% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=6></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=22 style="font-size:11px">&nbsp;<font color=c00000><b>�� ���Կ�� �� ���ǻ���</b></font></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� ������ ���� ���θ�Ī���� �ݵ�� ����Ͻʽÿ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��) ���Ǿ� 1.5 RS</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� ����Ÿ��� �ܴ������� �����Ͻʽÿ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp;<b> �� �ܰ����´� �ش� ������ ���� ǥ���ϰ� �����̷��� �����ÿ���<br>&nbsp;&nbsp;&nbsp;&nbsp;  �ܺο� ǥ���Ͻʽÿ�.</b></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� ������������� ������, �����, ��������, �������� ���� ����<br>&nbsp;&nbsp;&nbsp;&nbsp;  �����Ͻʽÿ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� �� �׸��� ��������� ������ �����Խ� �׿� ���� �Ρ������� å����<br>&nbsp;&nbsp;&nbsp;&nbsp; ��ǰ�ڰ� ���� �Ǵ� �����Ͻñ� �ٶ��ϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� �μ��ڷκ��� �ߴ��� Ŭ����(����)�� ����� ��� ��ǰ��������<br>&nbsp;&nbsp;&nbsp;&nbsp; ���� ó���ؾ� �� �ǹ��� �ֽ��ϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� </b>������ Ź�۷�� ������ݿ��� �����ϸ�, ������ ����� �԰� �� ��<br>&nbsp;&nbsp;&nbsp;&nbsp; ���� Ź�۷�� �� �δ����� �����Ͻñ� �ٶ��ϴ�.</b></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=13></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=99% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd colspan=2 height=18><span class=style5>�� ���񼭷� ( ����� ������ Vǥ�� �ٶ��ϴ� )</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#FFFFFF height=18><span class=style5>����/���λ����</span></td>
                                                                    <td align=center bgcolor=#FFFFFF><span class=style5>���λ����</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td bgcolor=#ffffff align=center width=49% valign=top>
                                                                        <table width=95% border=0 cellpadding=0 cellspacing=0>
                                                                            <tr>
                                                                                <td height=5></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ�������� ����</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ΰ����� 1��</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ����絵���� ������(�ΰ�����)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ�����(���漼) ��������</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ����� ���Ұ���û��(�ΰ�<����)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� ����ڵ���� �纻 1��(���λ����)</font></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td bgcolor=#ffffff align=center width=51%>
                                                                        <table width=95% border=0 cellpadding=0 cellspacing=0>
                                                                            <tr>
                                                                                <td height=5></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ�������� ����</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� ���� �ΰ�����/���ε ��1��</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ����絵���� ������(�ΰ�����)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ�����(���漼) ��������</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ����� ���Ұ���û��(�ΰ�����)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� ����ڵ������� (��, ��뺻������<br>&nbsp;&nbsp;&nbsp; �������� �ּҰ� ������ ��츸 ����)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=3></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=7></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=97% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=24 width=20%><img src=/acar/images/content/glovis.gif align=absmiddle></td>
                                <td><b>���롤����ڵ��������</td>
                                <td align=right><b>������ȭ :</b> 031-760-5300, 5354, 5350&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>FAX :</b> 031-760-5390</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
</table>

</form>
</div>
<!--��ǰ��û�� ��-->
<!-- ǰ�������� -->

<form name='form3' method='post' action=''>

<div>
<table width=754 border=0 cellpadding=18 cellspacing=1 bgcolor=5B608C>
    <tr>
        <td bgcolor=#FFFFFF valign=top align=center>
            <table width=708 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=20% align=center><img src=/acar/images/content/logos.gif width=92 height=25></td>
                    <td align=right valign=bottom>������ȣ : <%=olyBean.getCar_doc_no()%> ȣ</td>
                </tr>
                <tr>
                    <td height=7 colspan=2 align=center></td></tr>
                <tr>
                    <td colspan=2><img src=/acar/images/content/bar2.gif width=708 height=37></td>
                </tr>
                <tr align=center>
                    <td colspan=2>
                        <table width=690 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=28>(��)�Ƹ���ī���� �Ǹ��� �ڵ����� ���� ���� ������ �Ʒ��� �����ϴ�. </td>
                            </tr>
                            <tr>
                                <td height=12><span class=style1>1. �߰����ڵ��� ǰ�� ��������</span></td>
                            </tr>
                            <tr>
                                <td height=20>�Ʒ��� ���� ������ ������ �� �帳�ϴ�. </td>
                            </tr>
                            <tr>
                                <td height=20>
                                    <table width=690 border=0 cellpadding=0 cellspacing=1 bgcolor=cde83a>
                                        <tr>
                                            <td width=20% align=center bgcolor=e4f778><span class=style2><font color=4e6101>��������</font></span></td>
                                            <td height=48 bgcolor=#FFFFFF style="font-size:11px">&nbsp;&nbsp;&nbsp;���� �� �����Ⱓ ���� �߻��� ���� �� Ʈ�����̼��� ������ ������ ��ǰ�� �������<br>
                                                &nbsp;&nbsp;&nbsp;(��, ����, �޺���̼Ƿ��� �� �ܰ� �� �Ҹ� ��ǰ�� ����)<br>
                                                &nbsp;&nbsp;&nbsp;* ���� ���� ���� ���� ����, ��ǰ�� ��ȯ �� ���� ������ ��� �������� �ʽ��ϴ�.</td>
                                        </tr>
                                        <tr>
                                            <td align=center bgcolor=e4f778><span class=style2><font color=4e6101>�����Ⱓ</font></span></td>
                                            <td height=48 bgcolor=#FFFFFF style="font-size:11px">&nbsp;&nbsp;&nbsp;�����Ⱓ : �����Ϸκ��� 7��<br>
                                                &nbsp;&nbsp;&nbsp;����Ÿ� : �� ����Ÿ� <%=AddUtil.parseDecimal(AddUtil.parseInt((String)olyBean.getKm())+1000)%>km �̳� (���� ����Ÿ� = <%=AddUtil.parseDecimal((String)olyBean.getKm())%>km)<br>
                                                &nbsp;&nbsp;&nbsp;* ��� ��¥ �Ǵ� ����Ÿ� �� ���� ������ ���� �����Ⱓ ����� ����</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=3></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style1>2. ��������</span></td>
                            </tr>
                            <tr>
                                <td height=20 style="font-size:11px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ���������� ��翡 �԰��Ͽ� ó���ϴ°��� ��Ģ���� �մϴ�. <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �������<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ������ ������ ���忡�� �� ��� ������ ���� ���� �ϼž� �մϴ�.                            <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- �ڵ��� ���ۻ簡 ������ ������ҿ��� �����ؾ� �մϴ�.                            <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- �ŷ�����(������), ���ݰ�꼭�� �ݵ�� ���� �Ǿ�� �մϴ�.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ��������� ��簡 ������ҿ� ���� �����մϴ�.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ��Ÿ �ڼ��� ������ ����� �ڵ��� �Ű� ����ڿ� ���� �Ͻʽÿ�.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ��翡 �԰� ������ ��������� ������ ���� �δ���(Ź�۷�,������ ��)�� ������ �δ��Դϴ�.</td>
                            </tr>
                            <tr>
                                <td height=22><span class=style1>3. ���� ��� ����</span></td>
                            </tr>
                            <tr>
                                <td height=20>
                                    <table width=690 border=0 cellpadding=0 cellspacing=1 bgcolor=cde83a>
                                        <tr align=center>
                                            <td width=20% height=20 bgcolor=e4f778><span class=style2><font color=4e6101>�� ��</font></span></td>
                                            <td width=30% bgcolor=#FFFFFF><span class=style4><%=olyBean.getCar_jnm()%></span></td>
                                            <td width=20% bgcolor=e4f778><span class=style2><font color=4e6101>������ȣ</font></span></td>
                                            <td bgcolor=#FFFFFF><span class=style4><%=olyBean.getCar_no()%></span></td>
                                        </tr>
                                        <tr align=center>
                                            <td height=20 bgcolor=e4f778><span class=style2><font color=4e6101>��������</font></span></td>
                                            <td bgcolor=#FFFFFF style="font-size:11px">&nbsp;\ <%=AddUtil.parseDecimal(olyBean.getCar_cs_amt() + olyBean.getCar_cv_amt() + olyBean.getSd_cs_amt() + olyBean.getSd_cv_amt())%></td>
                                            <td bgcolor=e4f778><span class=style2><font color=4e6101>�����ȣ</font></span></td>
                                            <td bgcolor=#FFFFFF style="font-size:11px"><%=olyBean.getCar_num()%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=2></td>
                            </tr>
                            <tr>
                                <td height=25><span class=style1>4. �����ϴ� �ڵ����� �̷� : ����</span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style1>5. �����ϴ� �ڵ����� ����̷� : ÷��</span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style6>�� ������� �ڵ����� ���� ���系���� ������� Ȯ���ϸ�, �� ���������� ����� ������ ���� Ȯ���մϴ�. </span></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan=2><img src=/acar/images/content/bar1.gif width=708 height=37></td>
                </tr>
                <tr align=center>
                    <td colspan=2 height=340>
                        <table width=690 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=28>�Ʒ��� ���� ��� �ڵ����� �������� ���Բ� ǲ �ɼ�(Put Option)�� �Ǹ��� �ο��մϴ�.</td>
                            </tr>
                            <tr>
                                <td  valign=top>
                                    <table width=690 border=0 cellspacing=0 cellpadding=0 background=/acar/images/content/put.JPG height=325>
                                        <tr>
                                            <td>
                                                <table width=690 border=0 cellpadding=0 cellspacing=0>
                                                    <tr>
                                                        <td height=17></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=198>&nbsp;</td>
                                                        <td width=421><font color=FFFFFF><b>ǲ�ɼ��̶�?</b></font></td>
                                                        <td width=39>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td height=10 colspan=3></td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td style="font-size:11px">
                                                        ���Բ��� ��簡 ��ǰ�� �ڵ����� ���� �޾�����, ���� ���� �ڵ����� �����Ⱓ��<br>
                                                        ����ϵ��� ó������ ���Ѱ��, ���� �ڵ����� ��翡 �ݳ��ϰ� ��������� 95%��<br>
                                                        ȯ�ҹ޴�
ȹ������ �ŷ������Դϴ�. �̴� ��簡 ���� ���ʷ� ���� �����Ͽ�����,��<br>
                                                        �� �� ��ǰ������ �Ǹ��� �����մϴ�. ��簡 ��ǰ�ϴ� ��� �ڵ����� �����ϴ� ǰ<br>
                                                        �������� �� �籸�� �������� Ȥ�� ���� ������ �ս��� �ּ�ȭ�ϰ�, ������ �ش�<br>ȭ�� �������ִ� ��� ������
�� ���� ���������̾������Դϴ�.<br><font color=999999>(��������:2008�� 04�� 25��)</font></td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=11></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td width=56>&nbsp;</td>
                                                        <td width=288 valign=top>
                                                            <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td><span class=style3>���Ⱓ</span> <span class=style5>: �����Ϸκ��� 52�� ~56��° (���Ϻһ���)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    (8���� �� ~ �ݿ�����)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=7></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>�ɼ���翡 ���� ������� ȯ��</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=5></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>1. ȯ������ : ���� �ڵ����� ������ �߱޵� �ɼǰŷ� ��<br>&nbsp;&nbsp;&nbsp;&nbsp;���� ����(�����, ��� ������ ��)�� ��ҿ� ��ȯ<br>&nbsp;&nbsp;
                                                                    &nbsp;�� �Ϸ�� ���� (���ึ���ð� ����,���ٹ��� ����)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=3></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>2. ȯ�ұݾ� : ���������� 95%(�ʿ����� ����)<br>&nbsp;&nbsp;&nbsp;&nbsp;(��, ������ �δ��� ����������, Ź�۷�, ������ ��<br>&nbsp;&nbsp;&nbsp;&nbsp;�δ����� ����)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=3></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>3. ȯ������ : ��3�� ������ �Ǵ� ��3�ڿ��� ���� ������<br>&nbsp;&nbsp;&nbsp;&nbsp;�����ϵ��� �������� ���� �� ����</span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=25>&nbsp;</td>
                                                        <td width=320>
                                                            <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td><span class=style3>�����</span><span class=style5> : ��翡 �ɼ���� �ǻ�ǥ�� (��,�������� ��<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ǰ��� ����ڿ��� �ǻ� ǥ�� �Ǵ� ����,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ѽ��� �̿�)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=9></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>�ɼ���� ���� ����</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=5></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>1. ����Ÿ� : &nbsp;&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)olyBean.getKm())+1000)%>km �ʰ�<br>&nbsp;&nbsp;&nbsp;&nbsp;(������ ����Ÿ� ��� 1000km �ʰ���)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=2></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>2. �����ջ��� �߻���</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=2></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>3. ��3�ڿ��� �絵�� ��� (������� ����)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=11></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>�ɼ���� �� �δ���<br>(Ź�۷�, ������� ���� ���δ�)</span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=25></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr align=center>
                    <td colspan=2>
                        <table width=670 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td height=20 align=right colspan=2><%=AddUtil.getDate3(Util.getDate())%>&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=right valign=middle width=83%><span class=style1>�ֽ�ȸ�� �Ƹ���ī ��ǥ�̻�</span></td>
                                <td align=right><img src=/acar/images/content/sign.gif  align=absmiddle></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=15 colspan=2>&nbsp;&nbsp;<span class=style6>�� �������ڿ� ������ ���ų�, ���� ������ ���� ��ȿ�Դϴ�.</span></td>
                </tr>
                <tr>
                    <td height=15 colspan=2>&nbsp;&nbsp;���� �������� ���ǵ��� 17-3 ����̾ؾ����� 8�� ( http://www.amazoncar.co.kr)  &nbsp;&nbsp;TEL. 02) 392-4243 / FAX. 02) 757-0803</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<!-- ǰ�������� �� -->
<div style="page-break-after: always"></div>
<%}%>
</body>
</html>

<script>
onprint();

function onprint(){
	
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}	

function IE_Print() {
	factory.printing.header = ""; //��������� �μ�
	factory.printing.footer = ""; //�������ϴ� �μ�
	factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
	factory.printing.leftMargin = 5.0; //��������   
	factory.printing.topMargin = 5.0; //��ܿ���    
	factory.printing.rightMargin = 5.0; //��������
	factory.printing.bottomMargin = 5.0; //�ϴܿ���
	factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>

