<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=scd_info_sn_excel.xls");
%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.user_mng.*, acar.cls.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<style type="text/css">
<!--
.style1 {color: #FFFFFF}
-->
</style>
<body>
<%
	String m_id		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd			= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	String b_dt 	= request.getParameter("b_dt")==null?"":request.getParameter("b_dt");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String bill_yn 	= request.getParameter("bill_yn")==null?"":request.getParameter("bill_yn");
	String cls_chk 	= request.getParameter("cls_chk")==null?"N":request.getParameter("cls_chk");
	
	String rst				= request.getParameter("rst")==null?"all":request.getParameter("rst");	// 2018.04.24
	String rst_full_size	= request.getParameter("rst_full_size")==null?"1":request.getParameter("rst_full_size");	// 2018.04.24 
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//��������� ��ȸ
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//�뿩�⺻����
	ContFeeBean fee = a_db.getContFee(m_id, l_cd, rent_st);
	
	int tae_sum = af_db.getTaeCnt(m_id);
	
	//�Ǻ� �뿩�� ������ ����Ʈ
	Vector fee_scd = af_db.getFeeScdNew3(m_id, l_cd, b_dt, mode, bill_yn, rst, true);	// ���� ����		2018.04.24
	int fee_scd_size = fee_scd.size();
	
	//��������
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
		
	//���� �޹�ȣ ������
	int car_no_len = String.valueOf(base.get("CAR_NO")).length();
	String car_no = "";
	if(car_no_len > 3){
		car_no = String.valueOf(base.get("CAR_NO")).substring(0,car_no_len-2)+"**";
	}
%>
<b>�� ������</b>
<br/>
	<%
		if(rst.equals("all") && Integer.parseInt(rst_full_size) > 1){
			for(int r=0; r<Integer.parseInt(rst_full_size); r++){
    			ContFeeBean[] ext_fee2 = new ContFeeBean[Integer.parseInt(rst_full_size)];
    			ext_fee2[r] = a_db.getContFeeNew(m_id, l_cd, Integer.toString(r+1));
    %>
<%if(r==0){%>�����뿩<%}else{%><%=r%>�� �뿩<%}%>
<table width=800 cellpadding=0 cellspacing=0 style="border-style: solid; border-width: thin;">
	<tr align=center>
		<td width=40% class=title bgcolor=#f2f2f2 colspan=11 style="border-style: solid; border-width: thin;">�뿩����</td>
	</tr>
	<tr>
		<td align=center class=content colspan=10 style="border-style: solid; border-width: thin;"><span class=style5
			>&#91;<%=base.get("CAR_NO")%>&#93; <%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span></td>
	</tr>
    <tr align=center>
        <td width=20% class=title bgcolor=#f2f2f2 colspan=4 style="border-style: solid; border-width: thin;">���뿩��(VAT����)</td>
        <td width=20% class=title bgcolor=#f2f2f2 colspan=2 style="border-style: solid; border-width: thin;">���뿩������</td>
        <td width=20% class=title bgcolor=#f2f2f2 colspan=2 style="border-style: solid; border-width: thin;">������(VAT����)</td>
        <td width=20% class=title bgcolor=#f2f2f2 colspan=3 style="border-style: solid; border-width: thin;">���ô뿩��(VAT����)</td>
    </tr>
    <tr>
        <td align=center class=content colspan=4 style="border-style: solid; border-width: thin;"><span class=style14
        	><%= Util.parseDecimal(ext_fee2[r].getFee_s_amt()+ext_fee2[r].getFee_v_amt()) %>��</span></td>
        <td align=center class=content colspan=2 style="border-style: solid; border-width: thin;"><span class=style7
        	><%=AddUtil.parseDecimal(ext_fee2[r].getGrt_amt_s())%>��</span></td>
        <td align=center class=content colspan=2 style="border-style: solid; border-width: thin;"><span class=style7
        	><%=AddUtil.parseDecimal(ext_fee2[r].getPp_s_amt()+ext_fee2[r].getPp_v_amt())%>��</span></td>
        <td align=center class=content colspan=3 style="border-style: solid; border-width: thin;"><span class=style7
        	><%=AddUtil.parseDecimal(ext_fee2[r].getIfee_s_amt()+ext_fee2[r].getIfee_v_amt())%>��</span></td>
    </tr>
    <tr align=center>
        <td class=title bgcolor=#f2f2f2 colspan=4 style="border-style: solid; border-width: thin;">�뿩�Ⱓ</td>
        <td class=title bgcolor=#f2f2f2 colspan=2 style="border-style: solid; border-width: thin;">�뿩������</td>
        <td class=title bgcolor=#f2f2f2 colspan=2 style="border-style: solid; border-width: thin;">�뿩������</td>
        <td class=title bgcolor=#f2f2f2 colspan=3 style="border-style: solid; border-width: thin;">���</td>
    </tr>
    <tr align=center>
        <td class=content colspan=4 style="border-style: solid; border-width: thin;"><span class=style7><%=ext_fee2[r].getCon_mon()%>����</span></td>
        <td class=content colspan=2 style="border-style: solid; border-width: thin;"><span class=style7><%=ext_fee2[r].getRent_start_dt()%></span></td>
        <td class=content colspan=2 style="border-style: solid; border-width: thin;"><span class=style7><%=ext_fee2[r].getRent_end_dt()%></span></td>
        <td class=content colspan=3 style="border-style: solid; border-width: thin;"><span class=style8></span></td>
    </tr>
</table>
<br/>
    <%
			}
		}else{
			ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, rst);
	%>
<table width=800 cellpadding=0 cellspacing=0 style="border-style: solid; border-width: thin;">
	<tr align=center>
		<td width=40% class=title bgcolor=#f2f2f2 colspan=11 style="border-style: solid; border-width: thin;">�뿩����</td>
	</tr>
	<tr>
		<td align=center class=content colspan=11 style="border-style: solid; border-width: thin;"><span class=style5
			>&#91;<%=base.get("CAR_NO")%>&#93; <%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span></td>
	</tr>
    <tr align=center>
        <td width=20% class=title bgcolor=#f2f2f2 colspan=4 style="border-style: solid; border-width: thin;">���뿩��(VAT����)</td>
        <td width=20% class=title bgcolor=#f2f2f2 colspan=2 style="border-style: solid; border-width: thin;">���뿩������</td>
        <td width=20% class=title bgcolor=#f2f2f2 colspan=2 style="border-style: solid; border-width: thin;">������(VAT����)</td>
        <td width=20% class=title bgcolor=#f2f2f2 colspan=3 style="border-style: solid; border-width: thin;">���ô뿩��(VAT����)</td>
    </tr>
    <tr>
        <td align=center class=content colspan=4 style="border-style: solid; border-width: thin;"><span class=style14
        	><%= Util.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt()) %>��</span></td>
        <td align=center class=content colspan=2 style="border-style: solid; border-width: thin;"><span class=style7
        	><%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>��</span></td>
        <td align=center class=content colspan=2 style="border-style: solid; border-width: thin;"><span class=style7
        	><%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>��</span></td>
        <td align=center class=content colspan=3 style="border-style: solid; border-width: thin;"><span class=style7
        	><%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>��</span></td>
    </tr>
    <tr align=center>
        <td class=title bgcolor=#f2f2f2 colspan=4 style="border-style: solid; border-width: thin;">�뿩�Ⱓ</td>
        <td class=title bgcolor=#f2f2f2 colspan=2 style="border-style: solid; border-width: thin;">�뿩������</td>
        <td class=title bgcolor=#f2f2f2 colspan=2 style="border-style: solid; border-width: thin;">�뿩������</td>
        <td class=title bgcolor=#f2f2f2 colspan=3 style="border-style: solid; border-width: thin;">���</td>
    </tr>
    <tr align=center>
        <td class=content colspan=4 style="border-style: solid; border-width: thin;"><span class=style7><%=ext_fee.getCon_mon()%>����</span></td>
        <td class=content colspan=2 style="border-style: solid; border-width: thin;"><span class=style7><%=ext_fee.getRent_start_dt()%></span></td>
        <td class=content colspan=2 style="border-style: solid; border-width: thin;"><span class=style7><%=ext_fee.getRent_end_dt()%></span></td>
        <td class=content colspan=3 style="border-style: solid; border-width: thin;"><span class=style8></span></td>
    </tr>
</table>
<br/>
	<%
		}
	%>
<b>�� �����뿩��յ���� ������</b>
<table width=648 cellpadding=0 cellspacing=0 style="border-style: solid; border-width: thin;">
	<tr bgcolor=#f2f2f2>
		<td width=20 height=32 align=center style="border-style: solid; border-width: thin;"><span style="color:#707166;font-family:nanumgothic;font-size:12px;">ȸ��</span></td>
        <td width=135 align=center style="border-style: solid; border-width: thin;"><span style="color:#707166;font-family:nanumgothic;font-size:12px;">���Ⱓ</span></td>
        <td width=70 align=center style="border-style: solid; border-width: thin;"><span style="color:#707166;font-family:nanumgothic;font-size:12px;">���ݰ�꼭<br>����</span></td>
        <td width=60 align=center style="border-style: solid; border-width: thin;"><span style="color:#707166;font-family:nanumgothic;font-size:12px;">���ް�</span></td>
        <td width=50 align=center style="border-style: solid; border-width: thin;"><span style="color:#707166;font-family:nanumgothic;font-size:12px;">�ΰ���</span></td>
        <td width=75 align=center style="border-style: solid; border-width: thin;"><span style="color:#707166;font-family:nanumgothic;font-size:12px;">���뿩��</span></td>
        <td width=60 align=center style="border-style: solid; border-width: thin;"><span style="color:#707166;font-family:nanumgothic;font-size:12px;">�Ա�����</span></td>
        <td width=75 align=center style="border-style: solid; border-width: thin;"><span style="color:#707166;font-family:nanumgothic;font-size:12px;">���Աݾ�</span></td>
        <td width=40 align=center style="border-style: solid; border-width: thin;"><span style="color:#707166;font-family:nanumgothic;font-size:12px;">��ü<br>�ϼ�</span></td>
        <td width=52 align=center style="border-style: solid; border-width: thin;"><span style="color:#707166;font-family:nanumgothic;font-size:12px;">��ü��</span></td>
        <td width=75 align=center style="border-style: solid; border-width: thin;"><span style="color:#707166;font-family:nanumgothic;font-size:12px;">���ݰ�꼭<br>��������</span></td>
	</tr>
	<tr bgcolor=#FFFFFF>
		<td colspan=11>
			<table width=646 border=0 cellspacing=0 cellpadding=0>
			<% 	if(fee_scd_size>0){
					for(int i = 0 ; i < fee_scd_size ; i++){
						FeeScdBean scd = (FeeScdBean)fee_scd.elementAt(i);
						if(cls_chk.equals("Y") && !scd.getTm_st1().equals("0") && scd.getBill_yn().equals("N")) continue;
			%>												
				<tr <%if(i%2 != 0){%>bgcolor=f7fae5<%}%>>
					<td width=21 height=23 align=center>
						<span style="color:#333333;font-family:nanumgothic;font-size:11px;">
						<%if(scd.getTm_st2().equals("2")){%>b<%}%>
						<%=scd.getFee_tm()%>
						</span>
					</td>
					<td width=136 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic;">
					<%if(scd.getTm_st1().equals("0")){%>
					<%=AddUtil.ChangeDate2(scd.getUse_s_dt())%>~<%=AddUtil.ChangeDate2(scd.getUse_e_dt())%>
					<%}else{%>
					�ܾ�
					<%}%>
					</span></td>
					<td width=71 align=center><span style="color:#6b930f;font-size:11px;font-family:nanumgothic;"><%=AddUtil.ChangeDate2(scd.getFee_est_dt())%></span></td>
					<td width=61 align=right><span style="color:#333333;font-size:11px;font-family:nanumgothic;"><%=Util.parseDecimal(scd.getFee_s_amt())%></span>&nbsp;</td>
					<td width=51 align=right><span style="color:#333333;font-size:11px;font-family:nanumgothic;"><%=Util.parseDecimal(scd.getFee_v_amt())%></span>&nbsp;</td>
					<td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic;"><b><%=Util.parseDecimal(scd.getFee_s_amt()+scd.getFee_v_amt())%></b> </span>&nbsp;</td>
				<%if(scd.getBill_yn().equals("Y")){%>
				<%		if( cls_chk.equals("Y") && scd.getRc_dt().equals(AddUtil.replace(cls.getCls_dt(),"-","")) ){%>
					<td width=61 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic;"></span></td>
					<td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic;"><b>0</b></span>&nbsp;</td>
				<%		}else{%>
					<td width=61 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic;"><%=AddUtil.ChangeDate2(scd.getRc_dt())%></span></td>
					<td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic;"><b><%=Util.parseDecimal(scd.getRc_amt())%></b></span>&nbsp;</td>
				<%		}%>
				<%}else{%>
					<td width=61 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic;"><%if(cls_chk.equals("Y")){%><%}else{%><%=AddUtil.replace(cls.getCls_dt(),"-","")%><%}%></span></td>
					<td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic;"><b><%if(cls_chk.equals("Y")){%>0��<%}else{%>�ߵ���������<%}%></b></span>&nbsp;</td>
				<%}%>
					<td width=41 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic;"><%=scd.getDly_days()%>��</span></td>
					<td width=52 align=right><span style="color:#333333;font-size:11px;font-family:nanumgothic;"><%=Util.parseDecimal(scd.getDly_fee())%></span>&nbsp;</td>
					<td width=52 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic;"><%=AddUtil.ChangeDate2(scd.getExt_dt())%></span></td>
				</tr>
		<%}}%>	
			</table>
		</td>
	</tr>
</table>
</body>
</html>