<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.pay_mng.*, acar.cont.*, acar.car_register.*, acar.accid.*, acar.cus_reg.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int    sh_height	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String r_acct_code 	= request.getParameter("r_acct_code")==null?"":request.getParameter("r_acct_code");
	String reqseq 		= request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int    i_seq 		= request.getParameter("i_seq")==null?0:AddUtil.parseInt(request.getParameter("i_seq"));
	
	String chk="0";
	long total_amt1	= 0;
	long total_amt2	= 0;
	
	CommonDataBase 		c_db = CommonDataBase.getInstance();
	AccidDatabase 		as_db = AccidDatabase.getInstance();
	PayMngDatabase 		pm_db = PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();


	//��ݿ���
	PayMngBean pay 	= pm_db.getPay(reqseq);
	
	if(i_seq ==0) i_seq =1;
	
	//��ݿ���
	PayMngBean item	= pm_db.getPayItem(reqseq, i_seq);
	
	//��ݿ��� ���� �׸�
	Vector vt =  pm_db.getPayItemList(reqseq);
	int vt_size = vt.size();
	
	if(i_seq == 0) i_seq = vt_size+1;
	
	
	//�����縮��Ʈ
	Vector bank_vt =  ps_db.getCodeList("0003");
	int bank_size = bank_vt.size();
	
	//������¹�ȣ
	Vector accs = ps_db.getDepositList();
	int acc_size = accs.size();	
	
	//Ź�ۻ���
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	//�����
	UsersBean reger_bean 	= umd.getUsersBean(pay.getReg_id());
	
	//������
	int user_size = c_db.getUserSize();
	
	if(user_size > 30 && user_size < 40){ 		user_size = 40;
	}else if(user_size > 40 && user_size < 50){ 	user_size = 50;
	}else if(user_size > 50 && user_size < 60){ 	user_size = 60;
	}else if(user_size > 60 && user_size < 70){ 	user_size = 70;
	}else if(user_size > 70 && user_size < 80){ 	user_size = 80;
	}else if(user_size > 80 && user_size < 90){ 	user_size = 90;
	}else if(user_size > 90 && user_size < 100){ 	user_size = 100; }
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&from_page="+from_page+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&reqseq="+reqseq+"";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" src="InnoAP.js"></script>
<script language="JavaScript">
<!--
	//��ĵ���
	function scan_file(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&reqseq=<%=reqseq%>&from_page=/fms2/pay_mng/pay_upd_step1.jsp&file_st="+file_st, "SCAN", "left=300, top=300, width=620, height=200, scrollbars=yes, status=yes, resizable=yes");
	}	
			
	function save()
	{
		var fm = document.form1;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");

			fm.action = 'pay_dir_user_reg1_step2_a.jsp';
			fm.target = 'i_no';
			fm.submit();	
			
			link.getAttribute('href',originFunc);	
		}
	}	
	
	//���ΰ�ħ
	function reload(){
		var fm = document.form1;			
		fm.action='pay_dir_user_reg1_step2.jsp';
		fm.target='d_content';
		fm.submit();
	}
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>  
  <input type='hidden' name='reqseq' 	value='<%=reqseq%>'>        
  <input type='hidden' name='from_page' value='<%=from_page%>'>      
  <input type='hidden' name='r_est_dt' 	value='<%=pay.getP_est_dt()%>'>            
  <input type='hidden' name='off_id' 	value='<%=pay.getOff_id()%>'>              
  <input type="hidden" name="rent_mng_id" value="<%=item.getP_cd1()%>">
  <input type="hidden" name="rent_l_cd" value="<%=item.getP_cd2()%>">
  <input type="hidden" name="car_mng_id" value="<%=item.getP_cd3()%>">
  <input type="hidden" name="client_id" value="">  
  <input type="hidden" name="accid_id" 	value="<%=item.getP_cd4()%>">
  <input type="hidden" name="serv_id" 	value="<%=item.getP_cd5()%>">
  <input type="hidden" name="maint_id" 	value="<%=item.getP_cd6()%>">  
  <input type='hidden' name='go_url' 	value='/fms2/pay_mng/pay_dir_user_reg1_step2.jsp'>      
  <input type='hidden' name='acct_code_nm' value=''>      
  <input type="hidden" name="ven_nm_cd" value="">
  <input type="hidden" name="mode" value="">  
  <input type="hidden" name="i_seq" value="<%=item.getI_seq()%>">    

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ��ݰ��� > <span class=style5>
						����������������ݵ�� (2�ܰ�)</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="15%" class=title>�����ȣ</td>
            <td >&nbsp;			  
              <%=reqseq%></td>
          </tr>		
          <tr>
            <td width="15%" class=title>�ŷ�����</td>
            <td >&nbsp;	<%=AddUtil.ChangeDate2(pay.getP_est_dt())%></td>
          </tr>		
          <tr>
            <td width="15%" class=title>��������</td>
            <td >&nbsp;	<%=AddUtil.ChangeDate2(pay.getP_est_dt2())%></td>
          </tr>		
          <tr>
            <td class=title>����ó</td>
            <td>&nbsp;
              <select name='off_st' class='default'>
				<option value="user_id"  <%if(pay.getOff_st().equals("user_id"))%>selected<%%>>�Ƹ���ī���</option>
              </select>
			  &nbsp;
              <%=pay.getOff_nm()%>
          </td>
          </tr>				  
          <tr>
            <td class=title>�׿����ŷ�ó</td>
            <td>&nbsp;
			  <%=pay.getVen_name()%></td>
          </tr>
          <tr>
            <td class=title>��������</td>
            <td><input type="hidden" name="ve_st" value="">&nbsp;
			  <input type="radio" name="ven_st" value="1" <%if(pay.getVen_st().equals("1"))	%>checked<%%>>
              �Ϲݰ���&nbsp;
              <input type="radio" name="ven_st" value="2" <%if(pay.getVen_st().equals("2"))	%>checked<%%> >
              ���̰���&nbsp;
              <input type="radio" name="ven_st" value="3" <%if(pay.getVen_st().equals("3"))	%>checked<%%> >
              �鼼&nbsp;
              <input type="radio" name="ven_st" value="4" <%if(pay.getVen_st().equals("4"))	%>checked<%%> >
              �񿵸�����(�������/��ü)&nbsp;
              <input type="radio" name="ven_st" value="0" <%if(pay.getVen_st().equals("0"))	%>checked<%%> >
              ����&nbsp;			  
              </td>
          </tr>	
          <tr>
            <td class=title>�ݾ�</td>
            <td>&nbsp; <%=AddUtil.parseDecimalLong(pay.getAmt())%></td>
          </tr>	  		    		  
          <tr>
            <td class=title>��ݹ��</td>
            <td>&nbsp; ������ü</td>
          </tr>
          <tr>
            <td class=title>�Աݰ���</td>
            <td >&nbsp;
              <select name='s_bank_id'>
                <option value=''>����</option>
                <%	for(int i = 0 ; i < bank_size ; i++){
								Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);
								%>
                <option value='<%= bank_ht.get("BANK_ID")%>' <%if(String.valueOf(bank_ht.get("BANK_ID")).equals(pay.getBank_id())||String.valueOf(bank_ht.get("NM")).equals(pay.getBank_nm()))	%>selected<%%>><%= bank_ht.get("NM")%></option>
                <%	}%>
              </select>
            <input type='text' name='bank_no' size='33' value='<%=pay.getBank_no()%>' class='default' >
			&nbsp;������ : <input type='text' name='bank_acc_nm' size='33' value='<%=pay.getBank_acc_nm()%>' class='default' > 
			<input type='hidden' name='bank_id' 	value='<%=pay.getBank_id()%>'>
			<input type='hidden' name='bank_nm' 	value='<%=pay.getBank_nm()%>'>
            (����ó ����, <font color="#FF0000">������ü�� ��</font>) </td>
          </tr>
          <tr>
            <td class=title>��ݰ���</td>
            <td >&nbsp;
			  <select name='deposit_no'>
                <option value=''>���¸� �����ϼ���</option>
                <%	if(acc_size > 0){
										for(int i = 0 ; i < acc_size ; i++){
											Hashtable acc = (Hashtable)accs.elementAt(i);%>
                <option value='<%= acc.get("DEPOSIT_NO")%>' <%if(String.valueOf(acc.get("DEPOSIT_NO")).equals(pay.getA_bank_no()))%>selected<%%>>[<%=acc.get("CHECKD_NAME")%>]<%= acc.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= acc.get("DEPOSIT_NAME")%></option>
                <%		}
									}%>
              </select> 
			  &nbsp;
			  (�Ƹ���ī ����) 
            </td>
          </tr>
          <%
                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
			String content_code = "PAY";
			String content_seq  = reqseq; 
			
			Vector attach_vt = attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
			int attach_vt_size = attach_vt.size();   
			
			if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
          %>
          <tr>
            <%if(j==0){%><td rowspan="5" class=title>��������</td><%}%>
            <td>&nbsp;
                <a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
                &nbsp;&nbsp;
                <a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
 	    </td>
         </tr>
         <%			}%>
         <%		}%>
         
         <%		for(int i=attach_vt_size;i < 5;i++){%>
          <tr>         
            <%if(attach_vt_size==0 && i==0){%><td rowspan="5" class=title>��������</td><%}%>   
            <td>&nbsp;
                <a href="javascript:scan_file('')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
 	    </td>
         </tr>                  
         <%		}%>          	  		  

		</table>
	  </td>
	</tr> 		
	<tr>
	  <td>�� ����� : <%=reger_bean.getUser_nm()%>, ����� : <%=pay.getReg_dt()%></td>
	</tr>  			
	<tr>
	  <td>�� 2�ܰ迡���� �������� ��ĵ����� �ϰ� �����ϼ���.&nbsp;</td>
	</tr> 
	<%	int pay_chk_cnt  =  pm_db.getPayRegChk2(pay);
		if(pay_chk_cnt>1 && pay.getReg_st().equals("D") && item.getP_st2().equals("���������")){%> 			
	<tr>
	  <td><font color=red>�� �ŷ�����, ����ó��, �ݾ��� ������ ���� �̹� ���ϵǾ� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.</font></td>
	</tr> 		
	<%	}%>	
    <tr>
	    <td align='right'>
	    <%//if( attach_vt_size > 0){%>	
	    <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%//}else{%>
	    * ���������� �����ϴ�. ������������ ��ĵ����ϰ� ���ΰ�ħ�� ���� ����Ͻʽÿ�. �����ϰ� �Ϸ�Ǹ� ��ݴ�������� ��ݿ�û �޽����� �߼��մϴ�.
	    &nbsp;&nbsp;<a href="javascript:reload()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_reload.gif align=absmiddle border=0></a>
	    <%//}%>
	    </td>
	</tr>	
	<tr>
	  <td><hr></td>
	</tr>  			
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���θ���Ʈ</span></td>
	</tr>  		
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="10%" class=title>����</td>
            <td width="10%" class=title>�������</td>
            <td width="10%" class=title>�ݾ�</td>						
            <td width="10%" class=title>����</td>			
            <td width="10%" class=title>��������</td>			
            <td width="50%" class=title>����</td>										
          </tr>
          <%total_amt1 	= AddUtil.parseLong(String.valueOf(pay.getAmt()));
		 	for(int i = 0 ; i < vt_size ; i++){
				PayMngBean pm = (PayMngBean)vt.elementAt(i);
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(pm.getI_amt()));%>			  
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center"><%=pm.getBuy_user_nm()%></td>			
            <td align="right"><%=AddUtil.parseDecimalLong(pm.getI_amt())%>��</td>
            <td align="center"><%=pm.getP_st2()%></td>			
            <td align="center"><%=pm.getAcct_code()%></td>			
            <td>&nbsp;<%=pm.getP_cont()%></td>												
          </tr>
	      <%}%>		
		</table>
	  </td>
	</tr> 				
	<tr>
	  <td>&nbsp;</td>
	</tr>  			
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>	
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

