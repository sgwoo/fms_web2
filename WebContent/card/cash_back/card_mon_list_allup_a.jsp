<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String st 	= request.getParameter("st")==null?"":request.getParameter("st");
	String card_kind 	= request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	String save_cng_yn = request.getParameter("save_cng_yn")==null?"":request.getParameter("save_cng_yn");
	
	String size = request.getParameter("size")==null?"":request.getParameter("size");
	String size2 = request.getParameter("size2")==null?"":request.getParameter("size2");
	String count = request.getParameter("count")==null?"":request.getParameter("count");
	
	int flag = 0;
	String reg_type = "C";
	int base_count = 0;
	
	String vid1[]  = request.getParameterValues("scd_serial");
	String vid2[]  = request.getParameterValues("scd_tm");
	String vid3[]  = request.getParameterValues("scd_amt");
	String vid4[]  = request.getParameterValues("scd_base_size");
	String vid5[]  = request.getParameterValues("save_amt");
	String vid6[]  = request.getParameterValues("incom_amt");
	String vid7[]  = request.getParameterValues("m_amt");

	String vid8[]  = request.getParameterValues("serial");
	String vid9[]  = request.getParameterValues("ven_name");
	String vid10[] = request.getParameterValues("base_amt");
	String vid11[] = request.getParameterValues("save_per");
	String vid12[] = request.getParameterValues("base_save_amt");
	
	String vid13[] = request.getParameterValues("s_ven_name");
	String vid14[] = request.getParameterValues("s_save_per");
	
	
	for(int i=0; i < AddUtil.parseInt(size); i++){

		//ī��ĳ���齺����
		CardStatBean scd_bean = CardDb.getCardStatScd(AddUtil.parseInt(vid1[i]), AddUtil.parseInt(vid2[i]));
		
		scd_bean.setSave_amt		(vid5[i]==null?0 :AddUtil.parseDigit4(vid5[i]));		
		scd_bean.setIncom_amt		(vid6[i]==null?0 :AddUtil.parseDigit4(vid6[i]));
		scd_bean.setM_amt				(vid7[i]==null?0 :AddUtil.parseDigit4(vid7[i]));
		
		//�Ա�ó��
		if(!CardDb.updateCardStatScd(scd_bean)) flag += 1;
		

		//�ܾ��̸�
		if(!vid2[i].equals("1")){
			base_count++; 
		//�ܾ��� �ƴϸ�
		}else{		
			for(int j=0; j < AddUtil.parseInt(vid4[i]); j++){
		
				reg_type = "C";
				
				CardStatBean csb_bean = CardDb.getCardStatBase(AddUtil.parseInt(vid8[base_count]));
	
				csb_bean.setUpdate_id(ck_acar_id);
	
				//ī�����	
				if(AddUtil.parseDigit4(vid10[base_count]) == 0 && AddUtil.parseDigit4(vid12[base_count]) == 0){
					if(!CardDb.updateCardStatCancel(csb_bean)) flag += 1;
					reg_type = "N";
				//��������	
				}else{
					csb_bean.setVen_name(vid9[base_count]==null?"":vid9[base_count]);
					csb_bean.setBase_amt(AddUtil.parseDigit4(vid10[base_count]));
					csb_bean.setSave_per(AddUtil.parseFloat(vid11[base_count]));
					csb_bean.setSave_amt(AddUtil.parseDigit4(vid12[base_count]));
					if(!CardDb.updateCardStatBase(csb_bean)) flag += 1;
				}
	
				//card_stat_scd ����
				if(!CardDb.updateCardStatScdRe(csb_bean)) flag += 1;
		
				if(reg_type.equals("C")){
	  			if(!CardDb.deleteCardStatScdRe(csb_bean)) flag += 1;
				}
	
				base_count++;
		
			}
		}
	}
	
	if(save_cng_yn.equals("Y")){
		for(int i=0; i < AddUtil.parseInt(size2); i++){
			CardStatBean csb_bean = CardDb.getCardStatSave(card_kind, vid13[i]);
			csb_bean.setSave_per(AddUtil.parseFloat(vid14[i]));
			if(!CardDb.updateCardStatSave(csb_bean)) flag += 1;
		}
	}
	
	
	//��ó��
	String  c_flag =  CardDb.call_sp_card_cont_reg();
	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'card_mon_list_allup.jsp';
		fm.target = "CardMonListAll";
		fm.submit();

		fm.action = 'card_mon_sc.jsp';
		fm.target = "c_foot";
		fm.submit();

	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='st' value='<%=st%>'>
<input type='hidden' name='card_kind' value='<%=card_kind%>'>
</form>
<a href="javascript:go_step()">��������</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		alert("ó���Ǿ����ϴ�.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
