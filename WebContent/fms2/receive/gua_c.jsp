<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.receive.*, acar.car_office.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.user_mng.*,   acar.cls.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rc_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "08", "10");		
	
	String ch_cd[]  = request.getParameterValues("ch_cd");

	int vid_size = ch_cd.length;

	String value[] = new String[4];

	String rent_mng_id	="";
	String rent_l_cd = "";
	String ext_tm = "";

	String s_pr="";

	for(int i=0; i < vid_size; i++){

		StringTokenizer st = new StringTokenizer(ch_cd[i],"/");
		int s=0;
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;

		}
		rent_mng_id		= value[1];
		rent_l_cd		= value[2];
		ext_tm		= value[3];

	}

	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
		
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getUse_yn().equals("Y"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());		
		
	//��������
	ClsBean cls_info = ac_db.getClsCase(rent_mng_id, rent_l_cd);
	
	Hashtable fee_base = rc_db.getClsContInfo(rent_mng_id, rent_l_cd);
	
	//rent_start_dt
	String  start_dt =  rc_db.getRent_start_dt(rent_l_cd);
	
	int  days =  c_db.getDays(  AddUtil.getDate(4), cls_info.getCls_dt());
	
	
	
	String ven_code = "";
	String ven_name = "";
	
	
	
	Vector cms_bnk = c_db.getCmsBank();	//������� �����´�.
	int cms_bnk_size1 = cms_bnk.size();
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd,  Integer.toString(fee_size));
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	
		
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	function save(){
		var fm = document.form1;
	
		if(fm.req_amt.value == "")		{ 	alert("û������ �Է��Ͻʽÿ�."); 		fm.req_amt.focus(); 		return;		}
		if(fm.req_dt.value == "")			{ 	alert("û������ �Է��Ͻʽÿ�."); 		fm.req_dt.focus(); 		return;		}
	
	//	if(fm.bank_nm.value == ""){ alert("�����ָ� �Է��Ͻʽÿ�."); return; }			
	//	if(fm.bank_no.value == '')	{ alert('������ Ȯ���Ͻʽÿ�.'); 	return;}
				
		
<%	     if ( gins.getGi_amt()  < 1)  {  %>
	             alert("�������谡�Աݾ��� �����ϴ�. Ȯ���ϼ���!!"); return; 	
<%	     } %>
						
		if(confirm('����Ͻðڽ��ϱ�?')){		
			fm.action='gua_c_a.jsp';
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
		}		
	}
	
	function enter(nm) {
		var keyValue = event.keyCode;
		if (keyValue =='13') {
			if(nm == 't_wd')	SearchopenBrWindow();
		}
	}	
		
	//�ڵ��� ��ȸ
	function SearchopenBrWindow()
	{
		var fm = document.form1;
		if(fm.t_wd.value == ""){ alert("�˻�� �Է��ϼ���!!"); return;}
		window.open("/fms2/receive/s_cls_cont.jsp?go_url=/fms2/receive/gua_reg_step1.jsp&s_kd=2&t_wd="+fm.t_wd.value, "CAR", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
			
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
 <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>

<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����⺻����</span></td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                              
                    <td width='12%' class='title' height="91">����ȣ</td>
                    <td height="17%">&nbsp;<%=fee_base.get("RENT_L_CD")%></td>
                    <td width='13%' class='title'>�����</td>
                    <td height="25%">&nbsp;������� : <%=c_db.getNameById((String)fee_base.get("BUS_ID2"),"USER")%> 
                      / ������� : <%=c_db.getNameById((String)fee_base.get("MNG_ID"),"USER")%></td>
                    <td width='12%' class='title'>�뿩���</td>
                    <td width='21%'>&nbsp; <%=fee_base.get("RENT_WAY")%></td>
                </tr>
                <tr> 
                    <td class='title'>��ȣ</td>
                    <td>&nbsp;<%=fee_base.get("FIRM_NM")%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=fee_base.get("CLIENT_NM")%></td>
                    <td class='title'>�뿩����</td>
                    <td>&nbsp;<%=fee_base.get("CAR_NM")%>&nbsp;<%=fee_base.get("CAR_NAME")%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<font color="#000099"><b><%=fee_base.get("CAR_NO")%></b></font></td>
                    <td class='title'>�����</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2((String)fee_base.get("INIT_REG_DT"))%></td>
                    <td class='title'>�뿩�Ⱓ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(start_dt)%>&nbsp;~&nbsp;<%=cls_info.getCls_dt()%></td>
                </tr>
                <tr> 
                   <td class='title' height="91">��������</td>
                    <td >&nbsp;<%=cls_info.getCls_st()%> </td>                    
                    <td class='title'>������</td>
                    <td>&nbsp;<%=cls_info.getCls_dt()%>&nbsp;&nbsp; <font color="#000099"> (�������:  <%=days%>��  ) </font></td>
                    <td class='title'>���̿�Ⱓ</td>
                    <td>&nbsp;<%=cls_info.getRcon_mon()%>����&nbsp;<%=cls_info.getRcon_day()%>��</td>
              
                </tr>          
                <tr> 
                    <td class='title' style='height:40'>�������� </td>
                    <td colspan="3">
                        <table border="0" cellspacing="0" cellpadding="3" width=100%>
                            <tr>
                                <td><%=cls_info.getCls_cau()%> </td>
                            </tr>
                        </table>
                    </td>
                      <td class='title'>���������</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(cls_info.getFdft_amt2())%>��</td>
                </tr>
            </table>
        </td>
    </tr>
    
    <tr>
        <td class=h></td>
    </tr> 
         
  <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������谡�Գ���</span></td>
	</tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr><td class=line2 style='height:1'></td></tr>           
    		    <tr>
        		    <td class='title' width=25%>���谡�Գ���</td>
        		    <td class='title' width=25%> �ְ��� �ݾ�</td>
        		    <td class='title' width=25%>��������</td>
        		    <td  class='title' > </td>
        		  </tr>
        		   <tr>
        		    <td  width=25% align=center><%=AddUtil.ChangeDate2(gins.getGi_start_dt())%>~<%=AddUtil.ChangeDate2(gins.getGi_end_dt())%></td>
        		    <td  width=25% align=right><%=AddUtil.parseDecimal(gins.getGi_amt())%></td>
        		     <td width=25% align=center ><%=gins.getGi_jijum()%></td>
        		     <td> </td>
        		   </tr>  
		    </table>
	    </td>
    </tr>


    <tr></tr><tr></tr>
        <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>û������</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		       
	                 <tr>
	                    <td width="12%" class=title rowspan=2>û������</td>
	                    <td width="12%" class=title rowspan=2>û���ݾ�</td>	                   
	                     <td width="24%" class=title  colspan=2>���������</td>
	                      <td width="12%" class=title  rowspan=2>�����</td>
	                      <td width="40%" class=title rowspan=2>�Աݿ�û����</td>	                
	                </tr>
	                  <tr>
	                    <td width="12%" class=title>�����</td>
	                     <td width="12%" class=title>����ó</td>
	                 </tr>
	       		<tr>
	       				  <td width="12%"  align=center>&nbsp;<input type='text' name='req_dt' value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td>
	                    <td width="12%"  align=center>&nbsp;<input type='text' name='req_amt' value='' size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); '></td>
	                   
	                     <td width="12%"  align=center >&nbsp;<input type='text' name='guar_nm' value='' size='20' class='text' ></td>
	                      <td width="12%"  align=center>&nbsp;<input type='text' name='guar_tel'  value='' size='20' class='text' ></td>
	                       <td width="12%" align=center>&nbsp;
	                          <select name='damdang_id'>
	                           <option value="">����</option>
				                <%	if(user_size > 0){
										for(int i = 0 ; i < user_size ; i++){
											Hashtable user = (Hashtable)users.elementAt(i); %>
				                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
				                <%		}
									}%>
				              </select>
				              </td>
				              <td width="40%" align=center>&nbsp;
				              <input type='text' name='bank_nm' value='260:����' size='20' class='text'  readonly >&nbsp;
				              <input type='text' name='bank_no' value='140-004-023871' size='20' class='text'  readonly >
				              </td>
             	
	             </tr>
		       </table>
		      </td>        
         </tr>   
     
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>				
	 <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id)  || nm_db.getWorkAuthUser("�������",user_id)  ) {%>
	 <tr>
	    <td align="center">&nbsp;<a href="javascript:save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>
	<% } %>		
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>				
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;	
//-->
</script>
</body>
</html>