<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=scd_info_excel.xls");
%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.user_mng.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>


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
	
	Vector fee_scd = new Vector();
	int fee_scd_size = 0;
	//�Ǻ� �뿩�� ������ ����Ʈ
	if(rent_st.equals("")){
		fee_scd = af_db.getFeeScdMail2(l_cd, false);
		fee_scd_size = fee_scd.size();
	}else{
		fee_scd = af_db.getFeeScdEmailRentst2(l_cd, rent_st, "", false);// �������� ������ �뿩���Ա� ������ 2018.04.13
		fee_scd_size = fee_scd.size();
		if(!rent_st.equals("1")) tae_sum=0;
	}
	
%>
<b>�� ������</b>
<table width=800 cellpadding=0 cellspacing=0 style="border-style: solid; border-width: thin;">
    <tr align=center>
        <td width=100% class=title bgcolor=#f2f2f2 colspan=4 style="border-style: solid; border-width: thin;">�뿩����</td>
    </tr>
    <tr>
        <td align=center class=content colspan=4 style="border-style: solid; border-width: thin;"><span class=style5><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span></td>
    </tr>
    <tr align=center>
    	<td width=25% class=title bgcolor=#f2f2f2 style="border-style: solid; border-width: thin;">���뿩��(VAT����)</td>
    	<td width=25% class=title bgcolor=#f2f2f2 style="border-style: solid; border-width: thin;">������</td>
    	<td width=25% class=title bgcolor=#f2f2f2 style="border-style: solid; border-width: thin;">������(VAT����)</td>
    	<td width=20% class=title bgcolor=#f2f2f2 style="border-style: solid; border-width: thin;">���ô뿩��(VAT����)</td>
    </tr>
    <tr>
    	<td align=center class=content style="border-style: solid; border-width: thin;"><span class=style14><%= Util.parseDecimal(fee.getFee_s_amt()) %>��</span></td>
    	<td align=center class=content style="border-style: solid; border-width: thin;"><span class=style7><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>��</span></td>
    	<td align=center class=content style="border-style: solid; border-width: thin;"><span class=style7><%=AddUtil.parseDecimal(fee.getPp_s_amt())%>��</span></td>
    	<td align=center class=content style="border-style: solid; border-width: thin;"><span class=style7><%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>��</span></td>
    </tr>
    
    <tr align=center>
        <td class=title bgcolor=#f2f2f2 style="border-style: solid; border-width: thin;">�뿩�Ⱓ</td>
        <td class=title bgcolor=#f2f2f2 style="border-style: solid; border-width: thin;">�뿩������</td>
        <td class=title bgcolor=#f2f2f2 style="border-style: solid; border-width: thin;">�뿩������</td>
        <td class=title bgcolor=#f2f2f2 style="border-style: solid; border-width: thin;">�ڵ�����Ϲ�ȣ</td>
    </tr>
    <tr align=center>
        <td class=content style="border-style: solid; border-width: thin;"><span class=style7><%=fee.getCon_mon()%>����</span></td>
        <td class=content style="border-style: solid; border-width: thin;"><span class=style7><%=fee.getRent_start_dt()%></span></td>
        <td class=content style="border-style: solid; border-width: thin;"><span class=style7><%=fee.getRent_end_dt()%></span></td>
        <td class=content style="border-style: solid; border-width: thin;"><span class=style8><%=base.get("CAR_NO")%></span></td>
    </tr>
</table>
<br/>
<b>�� �뿩�� ������</b>
<table width=800 cellpadding=0 cellspacing=0 style="border-style: solid; border-width: thin;">
	<tr bgcolor=#f2f2f2>
		<td width=7% align=center height=24 class=title style="border-style: solid; border-width: thin;">ȸ��</td>
		<td width=28% align=center class=title style="border-style: solid; border-width: thin;">���Ⱓ</td>
		<td width=15% align=center class=title style="border-style: solid; border-width: thin;">�Աݿ�������</td>
		<td width=16% align=center class=title style="border-style: solid; border-width: thin;">���ް�</td>
		<td width=16% align=center class=title style="border-style: solid; border-width: thin;">�ΰ���</td>
		<td width=18% align=center class=title style="border-style: solid; border-width: thin;">���뿩��</td>
	</tr>
	<tr bgcolor=#FFFFFF>
		<td colspan=6>
			<table width=680 border=0 cellspacing=0 cellpadding=0>
				<% 	if(fee_scd_size>0){
				for(int i = 0 ; i < fee_scd_size ; i++){
					FeeScdBean scd = (FeeScdBean)fee_scd.elementAt(i);%>												
				<tr <%if(i%2 != 0){%>bgcolor=f7fae5<%}%>>
					<td width=41 height=18 align=center>
						<span class=style10>
                <%if(scd.getTm_st2().equals("2")){%>b<%}%>
                <%=scd.getFee_tm()%>
                    	</span>
                    </td>
                    <td width=172 align=center><span class=style12><%=AddUtil.ChangeDate2(scd.getUse_s_dt())%> ~ <%=AddUtil.ChangeDate2(scd.getUse_e_dt())%> </span></td>
                    <td width=117 align=center><span class=style11><%=AddUtil.ChangeDate2(scd.getFee_est_dt())%></span></td>
                    <td width=106 align=right><span class=style12><%=Util.parseDecimal(scd.getFee_s_amt())%></span>&nbsp;&nbsp;</td>
                    <td width=106 align=right><span class=style12><%=Util.parseDecimal(scd.getFee_v_amt())%></span>&nbsp;&nbsp;</td>
                	<td width=137 align=right><span class=style11><b><%=Util.parseDecimal(scd.getFee_s_amt()+scd.getFee_v_amt())%></b> </span>&nbsp;&nbsp;</td>
				</tr>
		<%}}%>	
			</table>
		</td>
	</tr>
</table>
<%if(tae_sum>0){%>
(ȸ���� b�� ǥ�õ� ���� <%if(String.valueOf(base.get("CAR_NO")).equals(taecha.getCar_no())){%>�����Ī����<%}else{%>���������<%}%> �������Դϴ�.)
<%}%>
</body>
</html>