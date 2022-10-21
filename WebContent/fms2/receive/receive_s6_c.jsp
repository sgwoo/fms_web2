<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.receive.*"%>
<%@ page import="acar.user_mng.*,   acar.cls.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rc_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
//	if(base.getUse_yn().equals("Y"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
		
		
	//��������
	ClsBean cls_info = ac_db.getClsCase(rent_mng_id, rent_l_cd);
	
	Hashtable fee_base = rc_db.getClsContInfo(rent_mng_id, rent_l_cd);
	
	//rent_start_dt
	String  start_dt =  rc_db.getRent_start_dt(rent_l_cd);
	
	int  days =  c_db.getDays(  AddUtil.getDate(4), cls_info.getCls_dt());
	
	//�߽�����
	ClsBandBean cls_band = rc_db.getClsBandInfo(rent_mng_id, rent_l_cd);
	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
		
		//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			
	
	
	function save(){
		var fm = document.form1;
				
		if(fm.req_dt.value == '')				{ alert('�Ҽ����ڸ� �Է��Ͻʽÿ�'); 		fm.req_dt.focus(); 		return;	}
		if (toInt(parseDigit(fm.suit_amt.value)) < 1 )				{ alert('�Ҽ۱ݾ��� �Է��Ͻʽÿ�'); 		fm.suit_amt.focus(); 		return;	}
				
		//�߽ɿ� ��ϵǾ����� Ȯ�� - �ݵ�� �߽ɿ� ��ϵǾ�� ��.
		<%-- if( <%=cls_band.getSeq()%> < 1 ) { alert('�߽ɵ���� �����ϼ���!!!'); 		fm.req_dt.focus(); 		return;	} --%>
		
		if(confirm('����Ͻðڽ��ϱ�?')){	
			fm.action='receive_6_c_a.jsp';	
//			fm.target='ii_no';
			fm.target='d_content';
			fm.submit();
		}		

	}
	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<body leftmargin="15">
<form name='form1' method='post' >
<input type='hidden' name='car_gu' 	value='<%=base.getCar_gu()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type='hidden' name='cmd' value=''>


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
                    <td colspan="5">
                        <table border="0" cellspacing="0" cellpadding="3" width=100%>
                            <tr>
                                <td><%=cls_info.getCls_cau()%> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
       
    <tr></tr><tr></tr><tr></tr>  	  
    
    <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ҽ۳���</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	     <tr>
		                    <td width="13%" class=title>�Ҽ�����</td>
		                    <td colspan=3>&nbsp;<input type='text' name='req_dt' value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 		           
	                </tr>
	                <tr> 
	                    <td class=title width=9%>�Ҽ�����</td>
	                    <td colspan=3 >&nbsp;
	                    <input type="radio" name="s_type" value="1" >����������������ȸ
						<input type="radio" name="s_type" value="2" >�λ�Ҽ�
						<input type="radio" name="s_type" value="N" >�ҼۺҰ�
	                    </td>                  
              	  </tr>
              	  <tr>
                     <td class=title>������</td>
                     <td >&nbsp;<input type="text" name="suit_dt" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                     <td class=title>������ȣ</td>
                     <td>&nbsp;<input type="text" name="suit_no" size="20" class=text  ></td>
                 	</tr>
                   <tr>     
                    <td class=title width=9%>�Ҽ۱ݾ�</td>
                    <td>&nbsp;<input type="text" name="suit_amt"   size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td class=title width=9%>�Ҽۺ��</td>
                    <td>&nbsp;<input type="text" name="amt1"   size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  </tr>
	                <tr> 
                    <td class=title> Ư�̻���</td>
                    <td colspan="3" height="76"> 
                     &nbsp;<textarea name="req_rem" cols="140" rows="3"></textarea>
                    </td>
                   </tr>	                
	            
		       </table>
		      </td>        
         </tr>   
               
     	</table>
      </td>	 
    </tr>	 
        
    <tr>
        <td></td>
    </tr>
		
    <tr>
	  <td align="center">&nbsp;<a href="javascript:save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>	
  </table>
	
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
