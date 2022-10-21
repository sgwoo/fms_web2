<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.forfeit_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	int idx = request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//�뿩�⺻����
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	//���ݰ�꼭 �����Ͻ������������� ����Ʈ
	Vector ht = af_db.getFeeScdStopList(m_id, l_cd);
	int ht_size = ht.size();
	
	//��üȽ��
	int dly_mon = af_db.getFeeScdDlyCnt(m_id, l_cd);
	
	//�Ͻ���������
	FeeScdStopBean fee_stop = af_db.getFeeScdStop(m_id, l_cd, seq);
	
	//�ְ��� ��ȸ
	FineDocBn = FineDocDb.getFineDoc(fee_stop.getDoc_id());
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function scd_stop(){
		var fm = document.form1;

		if(fm.stop_st[0].checked != true && fm.stop_st[1].checked != true){	alert('���������� �����Ͻʽÿ�'); 		fm.stop_st[0].focus(); 		return; }
		if(fm.stop_s_dt.value 	== '')			{	alert('�����Ⱓ�� �Է��Ͻʽÿ�'); 								fm.stop_s_dt.focus(); 		return; }
		if(fm.stop_cau.value 	== '')			{	alert('���������� �Է��Ͻʽÿ�'); 								fm.stop_cau.focus(); 		return; }
		
		if(fm.seq.value == ''){
			if(fm.stop_st[0].checked == true){
				//if(fm.stop_doc_dt.value 	== '')	{	alert('��������߽����� �Է��Ͻʽÿ�'); 					fm.stop_doc_dt.focus(); 	return; }
				fm.stop_e_dt.value = '99999999';
			}else{
				if(fm.stop_e_dt.value 	== '')		{	alert('�����Ⱓ�� �Է��Ͻʽÿ�'); 							fm.stop_e_dt.focus(); 		return; }
				/*
				if(fm.stop_tax_dt.value 	== '')	{	alert('�ϰ������ϸ� �Է��Ͻʽÿ�'); 						fm.stop_tax_dt.focus(); 	return; }
				//�������� ���� �б⳻���� �����Ⱓ  �� �ϰ������� ����
				var year = fm.today.value.substr(0,4);
				var month = fm.today.value.substr(5,2);
				var s_dt;
				var e_dt;
				if(month == '01' || month == '02' || month == '03')			{	s_dt = year+'-01-01'; e_dt = year+'-03-31'; }
				else if(month == '04' || month == '05' || month == '06')	{ 	s_dt = year+'-04-01'; e_dt = year+'-06-30'; }
				else if(month == '07' || month == '08' || month == '09')	{ 	s_dt = year+'-07-01'; e_dt = year+'-09-31'; }
				else if(month == '10' || month == '11' || month == '12')	{ 	s_dt = year+'-10-01'; e_dt = year+'-12-31'; }
				if(fm.stop_s_dt.value < s_dt){		alert('�����Ⱓ�� Ȯ���Ͻʽÿ�'); 				fm.stop_s_dt.focus(); 		return; }
				if(fm.stop_e_dt.value > e_dt){		alert('�����Ⱓ�� Ȯ���Ͻʽÿ�'); 				fm.stop_e_dt.focus(); 		return; }
				if(fm.stop_tax_dt.value > e_dt){	alert('�ϰ������ϸ� Ȯ���Ͻʽÿ�'); 			fm.stop_tax_dt.focus(); 	return; }
				*/
			}
		}
		
		if(confirm('���ݰ�꼭 �Ͻ������� ����Ͻðڽ��ϱ�?'))
		{							
			fm.action = './fee_scd_u_stop_a.jsp';
			fm.target = 'i_no';
//			fm.target = 'ScdStopList';
			fm.submit();
		}
  	}
  
  	function cng_display(){
		var fm = document.form1;
		if(fm.stop_st[0].checked == true){
			tr_stop11.style.display	= '';
			tr_stop12.style.display	= '';
			tr_stop2.style.display	= 'none';
			td_stop1.style.display	= 'none';			
		}else if(fm.stop_st[1].checked == true){
			tr_stop11.style.display	= 'none';
			tr_stop12.style.display	= 'none';
			tr_stop2.style.display	= '';		
			td_stop1.style.display	= '';
			var year = fm.today.value.substr(0,4);
			var month = fm.today.value.substr(5,2);
			var s_dt;
			var e_dt;
			if(month == '01' || month == '02' || month == '03')			{	s_dt = year+'-01-01'; e_dt = year+'-03-31'; }
			else if(month == '04' || month == '05' || month == '06')	{ 	s_dt = year+'-04-01'; e_dt = year+'-06-30'; }
			else if(month == '07' || month == '08' || month == '09')	{ 	s_dt = year+'-07-01'; e_dt = year+'-09-31'; }
			else if(month == '10' || month == '11' || month == '12')	{ 	s_dt = year+'-10-01'; e_dt = year+'-12-31'; }
			fm.stop_s_dt.value = s_dt;
			fm.stop_e_dt.value = e_dt;
			fm.stop_tax_dt.value = e_dt;			
		}  
	}
  
	function view_stop(seq){
	 	var fm = document.form1;
		fm.seq.value = seq;
		fm.action = 'fee_scd_u_stoplist.jsp';
		fm.target = 'ScdStopList';		
		fm.submit();
  	}
	
	//�������� �˻��ϱ�
	function search(){
		var fm = document.form1;	
		window.open("/acar/settle_doc_mng/settle_doc_mng_sc_in.jsp?gubun2=5&s_kd=1&t_wd=<%=base.get("FIRM_NM")%>&from_page=/fms2/con_fee/fee_scd_u_stop.jsp", "SETTLE_DOC_LIST", "left=350, top=150, width=800, height=400, scrollbars=yes");		
	}

	//�������� �˻��ϱ�
	function doc_search(){
		var fm = document.form1;	
		window.open("fee_scd_u_stop_doc_list.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>", "SETTLE_DOC_LIST", "left=350, top=150, width=800, height=400, scrollbars=yes");		
	}
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<body topmargin=0 leftmargin=0>

<form action='' method="post" name='form1'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='rent_start_dt' value='<%=fee.getRent_start_dt()%>'>
<input type='hidden' name='rent_end_dt' value='<%=fee.getRent_end_dt()%>'>
<input type='hidden' name='t_fee_pay_tm' value='<%=fee.getFee_pay_tm()%>'>
<input type='hidden' name='stop_size' value='<%=ht_size%>'>
<input type='hidden' name='today' value='<%=AddUtil.getDate()%>'>
<input type='hidden' name='seq' value='<%=fee_stop.getSeq()%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr><td class=line2></td></tr>
    <tr>
	    <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
	        <%if(dly_mon > 0){%>
                <tr>
                    <td width='15%' colspan="2" class='title'>������Ȳ</td>
                    <td>&nbsp; 
                      <%=dly_mon%>���� ��ü
                    </td>
                </tr>
	        <%}%>
                <tr>
                    <td colspan="2" class='title'>����</td>
                    <td>&nbsp;
        			  <%String stop_st = fee_stop.getStop_st();
        			  	if(stop_st.equals("") && dly_mon>0)	stop_st = "1";%>
                      <input type="radio" name="stop_st" value="1" <%if(stop_st.equals("1")){%>checked<%}%>>
                      ��ü
                      <input type="radio" name="stop_st" value="2" <%if(stop_st.equals("2")){%>checked<%}%>> 
                      ����û
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>���ұ���</td>
                    <td>&nbsp;
        			  <%if(!fee_stop.getRent_seq().equals("1")&& !fee_stop.getRent_seq().equals("")){%>����<%=fee_stop.getRent_seq()%><%}%>
                    </td>
                </tr>				
                <tr>
                    <td colspan="2" class='title'>�����Ⱓ</td>
                    <td>
                        <table width="300"  border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="115">&nbsp;
                				<input type='text' name='stop_s_dt' value='<%=AddUtil.ChangeDate2(fee_stop.getStop_s_dt())%>' maxlength='12' size='12' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
                                  ����</td>
                                <td width="115"><input type='text' name='stop_e_dt' value='<%=AddUtil.ChangeDate2(fee_stop.getStop_e_dt())%>' maxlength='12' size='12' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
                                  ����</td>
                                <td></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>����</td>
                    <td>&nbsp;
                      <textarea name="stop_cau" cols="92" rows="3" class=default><%=fee_stop.getStop_cau()%></textarea>
                    </td>
                </tr>
                <tr id=tr_stop11>
                    <td width=5% rowspan="3" class='title'>��<br>
                    ��<br>
                    ��<br>��</td>
                    <td class='title' width=10%>������ȣ</td>
                    <td>&nbsp;
                      <input type='text' name='stop_doc_id' value='<%=FineDocBn.getDoc_id()%>' maxlength='20' size='20' class='text'>
        			  		<a href="javascript:doc_search();"><img src="/acar/images/center/button_in_search1.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <tr id=tr_stop12>
                    <td class='title'>��������</td>
                    <td>&nbsp;
			        <input type='text' name='stop_doc_dt' value='<%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%>' size='30' class='whitetext'></td>
                </tr>
                <tr id=tr_stop12>
                    <td class='title'>��ĵ</td>
                    <td>&nbsp;			  
			        <input type='text' name='stop_doc' value='<%=FineDocBn.getFilename()%>' size='50' class='whitetext'>
			        <%if(!FineDocBn.getFilename().equals("")){%><a href="https://fms3.amazoncar.co.kr/data/stop_doc/<%=FineDocBn.getFilename()%>" target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a><%}%></td>
                </tr>
                <tr id=tr_stop3>
                    <td colspan="2" class='title'>����������</td>
                    <td>&nbsp;
                    <input type='text' name='cancel_dt' value='<%=AddUtil.ChangeDate2(fee_stop.getCancel_dt())%>' maxlength='12' size='12' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
			        </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr>
	    <td><span class="style1">* ����û�� ���� ������ �б������ �̷�� ���ϴ�. </span></td>
    </tr>	
    <tr>
	    <td><span class="style1">* �����Ⱓ ������ : ������ �������� ���Ⱓ �������� ��������.</span></td>
    </tr>		
    <tr>
	    <td><span class="style1">* ��ü�����϶��� �����Ⱓ �������� 9999-99-99�� �ڵ����õ˴ϴ�. ����û������ �������� �Է��ϼ���.</span></td>
    </tr>		
    <tr>
	    <td><span class="style1">* ��������� �Ϸ��� ��ü�϶��� ������������, ����û�϶��� �߱�Ⱓ �������� ���ú��� �������� �ϸ� �˴ϴ�.</span></td>
    </tr>		
	<tr>
	    <td align="center">
	  <%if(!mode.equals("view")){%>
	        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
      		&nbsp;&nbsp;<%if(seq.equals("")){%><a href="javascript:scd_stop();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a><%}else{%><a href="javascript:scd_stop();"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a><%}%>			
      		<%}%>
      <%}%>			
      		&nbsp;&nbsp;
      				<a href="javascript:parent.window.close();"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
      		
	    </td>
	</tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
