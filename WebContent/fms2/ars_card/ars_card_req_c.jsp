<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.ars_card.*, acar.doc_settle.*, acar.car_sche.*"%>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	CarSchDatabase csd = CarSchDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "05", "12", "26");	
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
	String ars_code 	= request.getParameter("ars_code")==null?"":request.getParameter("ars_code");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
		
	ArsCardBean ars = ar_db.getArsCard(ars_code);
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettle(doc_no);
		
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("35", ars_code);
		doc_no = doc.getDoc_no();
	}
	
	if(!doc.getUser_id1().equals("")){
		//���������
		user_bean 	= umd.getUsersBean(doc.getUser_id1());
	}
	
	
	String update_yn = "N";
	if(ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("����ī�������",user_id) || nm_db.getWorkAuthUser("����������",user_id)){
    	if(ars.getApp_id().equals("") && doc.getUser_dt1().equals("")){
    		update_yn = "Y";
    	}
    }	
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����Ʈ
	function list(){
		var fm = document.form1;	
		fm.action = 'ars_card_frame.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//���
	function save(mode){
		var fm = document.form1;
		
		fm.cng_item.value = mode;
		
		if(confirm('ó�� �Ͻðڽ��ϱ�?')){	
			fm.action='ars_card_req_u_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}			
	}


	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		if(doc_bit == '1'){
			if(fm.exempt_yn.value == 'Y'){
				if(fm.exempt_cau.value == '')		{ alert('������ ���������� �Է��Ͻʽÿ�.'); 			fm.exempt_cau.focus(); 	return; }
			}						
		}
				
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='ars_card_sanction.jsp';		
			fm.target='i_no';
			//fm.target='_blank';
			fm.submit();
		}									
	}	
	
	function Infini_Reg(){
		var fm = document.form1;
		fm.target="i_no";				
		<%if(ck_acar_id.equals("000029")){%>
		if(fm.view_check.checked == true){
			fm.target="_blank";
		}	
		<%}%>
		fm.action = "innopayPg_req.jsp";
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
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='ars_code' 	value='<%=ars_code%>'>
  <input type='hidden' name="cng_item" value="">
  <input type='hidden' name="doc_no" value="<%=doc_no%>">
  <input type='hidden' name="doc_bit" value="">
           
        
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > <span class=style5>ARS������û</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td align='right'><a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>	    
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ſ�ī����� û����</span></td>
    </tr>      
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
               <tr> 
                    <td class=title width=10%>������ȣ</td>
                    <td>&nbsp;<%=ars_code%></td>
                </tr>	
               <tr> 
                    <td class=title width=10%>���</td>
                    <td>&nbsp;<font color=red>
                        <%=ars.getReg_dt()%></font>&nbsp;<%=c_db.getNameById(ars.getReg_id(),"USER")%>
                    </td>
                </tr>	
                <tr> 
                    <td class=title width=10%>�����</td>
                    <td>&nbsp;
                        ������� : <%=ars.getBus_nm()%> / ȸ���� : <%=ars.getMng_nm()%>
                    </td>
                </tr>	
                <tr> 
                    <td class=title width=10%>����</td>
                    <td>&nbsp;
                        <textarea name='msg' rows='5' cols='90' class='text' style='IME-MODE: active'><%=ars.getGood_cont()%></textarea>                        
                    </td>
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
                    <td class=title width=10%>�����ڸ�</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_name' size='60' value='<%=ars.getBuyr_name()%>' class='whitetext' readonly></td>
                </tr>								
                <tr> 
                    <td class=title width=10%>��ǰ��</td>
                    <td>&nbsp;
                        <input type='text' name='good_name' size='60' value='<%=ars.getGood_name()%>' class='text'></td>
                </tr>								
                	                						
                <tr> 
                    <td class=title width=10%>ä�Ǳݾ�</td>
                    <td>&nbsp;
                        <input type='text' name='settle_mny' size='10' value='<%=AddUtil.parseDecimal(ars.getSettle_mny())%>' <%if(update_yn.equals("Y")){%>class='num'<%}else{%>class='whitenum' readonly<%}%> >��
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=10%>ī�������</td>
                    <td>&nbsp;
                        <input type='text' name='card_fee' size='10' value='<%=AddUtil.parseDecimal(ars.getCard_fee())%>' <%if(update_yn.equals("Y")){%>class='num'<%}else{%>class='whitenum' readonly<%}%> >��
                        &nbsp;(<input type='text' name='card_per' size='3' value='<%=ars.getCard_per()%>' class='whitetext' style="text-align:right;" readonly>%)
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=10%>ī�����ݾ�</td>
                    <td class=is>&nbsp;
                        <input type='text' name='good_mny' size='10' value='<%=AddUtil.parseDecimal(ars.getGood_mny())%>' <%if(update_yn.equals("Y")){%>class='num'<%}else{%>class='whitenum' readonly<%}%>>��                        
                        &nbsp;<%if(ars.getExempt_yn().equals("Y")){%>(���������)<%}else{%>(ä�Ǳݾ�+ī�������)<%} %>
                    </td>
                </tr>	
                <tr> 
                    <td class=title width=10%>�޴�����ȣ</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_tel2' size='30' value='<%=ars.getBuyr_tel2()%>' class='text'>(���ڹ߼�)</td>
                </tr>								
                <tr> 
                    <td class=title width=10%>�̸���</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_mail' size='30' value='<%=ars.getBuyr_mail()%>' class='text' style='IME-MODE: inactive'>(�ſ�ī�������ǥ�߼�)</td>
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
                <%if(ars.getApp_st().equals("1")){%>
                <tr> 
                    <td class=title width=10%>�ſ�ī���</td>
                    <td>&nbsp;
                        <select name="card_kind" disabled>
			    <option value="">����</option>
			    <option value="BCī��"   <%if(ars.getCard_kind().equals("BCī��")){%>selected<%}%>>BCī��</option>
			    <option value="�Ｚī��" <%if(ars.getCard_kind().equals("�Ｚī��")){%>selected<%}%>>�Ｚī��</option>
			    <option value="����ī��" <%if(ars.getCard_kind().equals("����ī��")){%>selected<%}%>>����ī��</option>			                                
			    <option value="��ȯī��" <%if(ars.getCard_kind().equals("��ȯī��")){%>selected<%}%>>��ȯī��</option>
			    <option value="����ī��" <%if(ars.getCard_kind().equals("����ī��")){%>selected<%}%>>����ī��</option>
			    <option value="�Ե�ī��" <%if(ars.getCard_kind().equals("�Ե�ī��")){%>selected<%}%>>�Ե�ī��</option>
			    <option value="�ϳ�SKī��" <%if(ars.getCard_kind().equals("�ϳ�SKī��")){%>selected<%}%>>�ϳ�SKī��</option>
			    <option value="NHä��ī��" <%if(ars.getCard_kind().equals("NHä��ī��")){%>selected<%}%>>NHä��ī��</option>			    
			    <option value="KB����ī��" <%if(ars.getCard_kind().equals("KB����ī��")){%>selected<%}%>>KB����ī��</option>
			</select>                                                
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=10%>�ſ�ī�� ��ȣ</td>
                    <td>&nbsp;
                        <%if(!ars.getApp_id().equals("")){%>
                        <input type='hidden' name="card_no" value="<%=ars.getCard_no()%>">
                        <%=AddUtil.ChangeCardStar(ars.getCard_no())%>
                        <%}else{%>
                        <input type='text' name='card_no' size='30' value='<%=AddUtil.ChangeCard(ars.getCard_no())%>' <%if(ars.getApp_st().equals("1") && (ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("����ī�������",ck_acar_id) || nm_db.getWorkAuthUser("����������",ck_acar_id))){%>class='text'<%}else{%>class='whitetext' readonly<%} %> >
                        <%}%>
                    </td>
                        
                </tr>								
                <tr> 
                    <td class=title width=10%>ī�� ��ȿ�Ⱓ</td>
                    <td>&nbsp;
                        <%if(!ars.getApp_id().equals("")){%>
                        **/**
                        <input type='hidden' name="card_y_mm" value="<%=ars.getCard_y_mm()%>">
                        <input type='hidden' name="card_y_yy" value="<%=ars.getCard_y_yy()%>">
                        <%}else{ %>
                        <input type='text' name='card_y_mm' size='2' value='<%=ars.getCard_y_mm()%>' <%if(ars.getApp_st().equals("1") && (ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("����ī�������",ck_acar_id) || nm_db.getWorkAuthUser("����������",ck_acar_id))){%>class='text'<%}else{%>class='whitetext' readonly<%} %> >��
                        /
                        <input type='text' name='card_y_yy' size='4' value='<%=ars.getCard_y_yy()%>' <%if(ars.getApp_st().equals("1") && (ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("����ī�������",ck_acar_id) || nm_db.getWorkAuthUser("����������",ck_acar_id))){%>class='text'<%}else{%>class='whitetext' readonly<%} %> >��
                        <!--
                        <select name="card_y_mm" <%if(ars.getApp_st().equals("1") && (ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("����ī�������",ck_acar_id) || nm_db.getWorkAuthUser("����������",ck_acar_id))){%><%}else{%>disabled<%} %>>
			    			<option value="">����</option>
	          	    		<%for(int i=1; i<=12; i++){%>
	          	    		<option value="<%=AddUtil.addZero2(i)%>" <%if(ars.getCard_y_mm().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
	          	    		<%}%>
	        			</select> 
                        <select name="card_y_yy" <%if(ars.getApp_st().equals("1") && (ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("����ī�������",ck_acar_id) || nm_db.getWorkAuthUser("����������",ck_acar_id))){%><%}else{%>disabled<%} %>>
                            <option value="">����</option>			    
			    			<%for(int i=AddUtil.getDate2(1); i<=(AddUtil.getDate2(1)+10); i++){%>
			    			<option value="<%=i%>" <%if(ars.getCard_y_yy().equals(String.valueOf(i))){%>selected<%}%>><%=i%>��</option>
			    			<%}%>
						</select>
						-->	        
			            <%}%>			           
                    </td>
                </tr>								
                <tr> 
                    <td class=title width=10%>�Һ� �Ⱓ</td>
                    <td>&nbsp;
                        <select name="quota">			    
			    <option value="" <%if(ars.getQuota().equals("�Ͻú�")){%>selected<%}%>>�Ͻú�</option>
	          	    <%for(int i=2; i<=6; i++){%>
	          	    <option value="<%=i%>" <%if(ars.getQuota().equals(String.valueOf(i))){%>selected<%}%>><%=i%>����</option>
	          	    <%}%>
			</select>                                                                    
                    <!--    (�����ڴ� ����)&nbsp;&nbsp;&nbsp;<a href="http://web.innopay.co.kr/" target=_blank title="ī��纰 ������ �Һ�">[ī��纰 ������ �Һ� Ȯ��]</a> -->
                             (�����ڴ� ����)&nbsp;&nbsp;&nbsp;* BCī�� 3���������� �Һ� ���� 
                    </td>
                </tr>	
                <%} %>                	
                <tr> 
                    <td class=title width=10%>ó��</td>
                    <td>&nbsp;
                        <select name="app_st" disabled>		
                        	<option value="3" <%if(ars.getApp_st().equals("3")){%>selected<%}%>>SMS����(��)</option>	    
                        	<option value="1" <%if(ars.getApp_st().equals("1")){%>selected<%}%>>ARS����(�Ƹ���ī)</option>
						</select> 
						
						<%if(ars.getApp_st().equals("1") && ars.getApp_id().equals("")){%>         
            			<%	if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("����ī�������",ck_acar_id) || nm_db.getWorkAuthUser("����������",ck_acar_id)){%>
            			&nbsp;&nbsp;
						&nbsp;&nbsp;<a href="javascript:save('msg');">[�Ա�ó����û]</a>
						<%	}%>
						<%	if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("�Աݴ��",ck_acar_id) || nm_db.getWorkAuthUser("��ݴ��",ck_acar_id)){%>
						&nbsp;&nbsp;<a href="javascript:save('app');"><img src=/acar/images/center/button_finish.gif align=absmiddle border=0></a>												
						<%	}%>
						<%}%>
									
                    </td>
                </tr>	                                
                
                <%if(!ars.getApp_id().equals("")){%>         
                <tr> 
                    <td class=title width=10%>�Ϸ�</td>
                    <td>&nbsp;
                        <%=ars.getApp_dt()%> <%=c_db.getNameById(ars.getApp_id(),"USER")%>
                        
                        <%if(ars.getCancel_dt().equals("")){%>
                        <%	if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("����ī�������",ck_acar_id) || nm_db.getWorkAuthUser("����������",ck_acar_id)){%>
						&nbsp;&nbsp;<a href="javascript:save('cancel');">[������ ���ó��]</a>												
						<%	}%>
                        <%} %>     
                    </td>
                </tr>	                           
                <%} %>   		
                
                <%if(!ars.getCancel_dt().equals("")){%>         
                <tr> 
                    <td class=title width=10%>�����������</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate2(ars.getCancel_dt())%>
                    </td>
                </tr>	                           
                <%} %>   	
    	    </table>
	</td>
    </tr> 	        
    <tr>
        <td class=h></td>
    </tr>
    <%if(ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("����ī�������",user_id) || nm_db.getWorkAuthUser("����������",user_id)){%>
    <%		if(ars.getApp_id().equals("") && doc.getUser_dt1().equals("")){%>
    <tr>
	<td align="right">		
	    <a href="javascript:save('u');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>    
	</td>
    </tr>	   
    <%	  	}%> 
    <%}%>
    <%	String ars_card_req_yn = "Y";%>
    
    <%	if(ars.getApp_st().equals("1")){
    		ars_card_req_yn = "ars";
    	} 
    %>
    <%if(ars.getExempt_yn().equals("Y")){
    	if(!doc.getDoc_step().equals("3")){
    		ars_card_req_yn = "not settle"; //����̿�
    	}	
    %>               
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> ������ ���� (������ ���� ��û�� �����-����-�ѹ�����-��ǥ�̻� ��������ý��� ó��)</span></td>
    </tr>      
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>    
                <tr> 
                    <td class=title width=10% colspan='3' style="height:30px;">������ ���� ����</td>
                    <td>&nbsp;
                        <input type="checkbox" name="w_exempt_yn" value="Y" <%if(ars.getExempt_yn().equals("Y")){%>checked<%}%> disabled> ������ ���� �Ѵ�.
                        <input type='hidden' name='exempt_yn' 	value='<%=ars.getExempt_yn()%>'>
                    </td>
                </tr>	
                <tr> 
                    <td class=title width=10% colspan='3' style="height:30px;">������ ���� ����</td>
                    <td>&nbsp;
                        <textarea name='exempt_cau' rows='5' cols='90' class='text' style='IME-MODE: active'><%=ars.getExempt_cau()%></textarea>
                    </td>
                </tr>	                 
    	    </table>
	</td>
    </tr> 	            
    <tr>
        <td>�� ������ȣ : <%=doc.getDoc_no()%></td>
    </tr>                              
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">����</td>
                    <td class=title width=15%>������</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%><%=doc.getUser_nm3()%></td>
                    <td class=title width=15%><%=doc.getUser_nm4()%></td>
                    <td class=title width=15%><%=doc.getUser_nm5()%></td>			
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center"><!--�����--><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%>
        			  <%if(doc.getUser_dt1().equals("")){%>
        			    <a href="javascript:doc_sanction('1')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%}%>
                    </td>
                    <td align="center"><!--����--><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
        			  <%if(!doc.getUser_id2().equals("XXXXXX")){
					    if(!doc.getDoc_step().equals("3") && !doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){
        			  		String user_id2 = doc.getUser_id2();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
        					if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	user_id2 = cs_bean.getWork_id();
        					%>
        			  <%	if(user_id2.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("������ڵ��������",user_id)){%>
        			    <a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
					  <%}else{%>
					    -<br>&nbsp;
					  <%}%>
        			</td>
                    <td align="center"><!--�ѹ�����--><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
        			  <%if(!doc.getDoc_step().equals("3") && !doc.getUser_dt1().equals("") && doc.getUser_dt3().equals("")){
        			  		String user_id3 = doc.getUser_id3();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);
        					if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	user_id3 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))		user_id3 = nm_db.getWorkAuthUser("��������");
        					%>
        			  <%	if(user_id3.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("������ڵ��������",user_id)){%>
        			    <a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>					  
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td>
                    <td align="center"><!--��ǥ�̻�-->-<br>&nbsp;</td>
                    <td align="center">&nbsp;</td>			
        	    </tr>	
    		</table>
	    </td>
	</tr>  	
	<%} %>
    <tr>
        <td class=h></td>
    </tr>	  
	<%if(ars_card_req_yn.equals("Y")){%>   
	
	<%		if(ars.getApp_id().equals("")){%>       
	<%			if(ars.getArs_step().equals("2")){%>
	<tr>
        <td align="center"><font color='red'>�� �̳����̿� ī����� ��û�� �Ǿ����ϴ�. ������ ����� �Դϴ�.</font></td>
    </tr> 
	<%			}else{ %>	
    <tr>
        <td align="center">
            <img src=/acar/images/center/icon_arrow.gif align=absmiddle> ������� : 
            <input type="radio" name="svcPrdtCd" value="04" checked>��ī��(04):ī��� ����Ͼ� ����
            &nbsp;
            <input type="radio" name="svcPrdtCd" value="03">�Ϲݵ��(03):ī���ȣ,��ȿ�Ⱓ,��й�ȣ �����Է�
            &nbsp;        	
        	<input type="button" class="button" value="�ſ�ī�����û���� �̳����� ���" onclick="javascript:Infini_Reg();">
        	<%if(ck_acar_id.equals("000029")){%>
        	&nbsp;&nbsp;   
        	<input type="checkbox" name="view_check" value="Y"> ����
        	<%} %>
        </td>
    </tr>    
    <tr>
        <td align="center"><font color='red'>�� [�ſ�ī�����û���� �̳����� ���] Ŭ���ϸ� �̳����̿� ī����� ��û�˴ϴ�.</font></td>
    </tr>      	
    <%			} %>
    <%		} %>
    
	<%}else if(ars_card_req_yn.equals("not settle")){ %>
    <tr>
        <td align="center">������ ������ ���簡 �Ϸ�� �Ŀ� �ſ�ī�����û���� �̳����̿� ��û�� �� �ֽ��ϴ�.</td>
    </tr>    		
	<%} %>    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
