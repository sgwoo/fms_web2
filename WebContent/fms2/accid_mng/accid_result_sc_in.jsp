<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.cont.*"%>
<%@ page import="acar.accid.*, acar.insur.*, acar.res_search.*, acar.car_service.*, acar.doc_settle.*, acar.pay_mng.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
<jsp:useBean id="oe_bean" class="acar.accid.OneAccidBean" scope="page"/>
<jsp:useBean id="my_bean2" class="acar.accid.MyAccidBean" scope="page"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="s_bean2" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="s_bean3" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//@ author : JHM - ���ó�������������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	String ins_st = "";
	String ins_com_nm  = "";
		
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarServDatabase csd = CarServDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	PaySearchDatabase ps_db = PaySearchDatabase.getInstance();
	
	Vector vt = d_db.getAccidResultDocList(s_kd, t_wd, gubun1);
	int vt_size = vt.size();
	
	String mng_mode = ""; 
	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����������",user_id) || nm_db.getWorkAuthUser("�λ�������δ��",user_id)){
		mng_mode = "A";
	}
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}			
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='a_size' 	value='<%=vt_size%>'>  
  <input type='hidden' name='from_page' value='/fms2/accid_mng/accid_result_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='670' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	        <tr>
	        <%if(mng_mode.equals("A")){%>   
		    <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		    <td width='30' class='title' style='height:45'>����</td>
		    <%}else{%>
		    <td width='60' class='title' style='height:45'>����</td>
		    <%}%>
		    <td width='60' class='title'>&nbsp;<br>����<br>&nbsp;</td>
		    <td width='130' class='title'>����Ͻ�</td>
        	<td width='170' class='title'>��</td>
		    <td width="80" class='title'>������ȣ</td>
		    <td width="120" class='title'>����</td>
		    <td width="50" class='title'>����<br>���</td>					
		</tr>
	    </table>
	</td>
	<td class='line' width='590'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td colspan="3" class='title'>����</td>					
		    <td width="70" rowspan="2" class='title'>�������</td>
		    <td width="120" colspan="2" class='title'>���Ǻ���</td>
		    <td width='200' rowspan="2" class='title'>������</td>								  
		</tr>
		<tr>
		    <td width='80' class='title'>�������</td>				
		    <td width='60' class='title'>�����</td>
		    <td width='60' class='title'>����</td>
		    <td width='60' class='title'>���</td>
		    <td width='60' class='title'>����</td>
	        </tr>
	    </table>
	</td>
    </tr>
<%
	if(vt_size > 0)
	{
%>
    <tr>
	<td class='line' width='680' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			//�����ȸ
			Hashtable cont = as_db.getRentCase(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")));
			
			//�����ȸ
			AccidentBean a_bean = as_db.getAccidentBean(String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("ACCID_ID")));
			
			//��������
			ins_st = ai_db.getInsStNow(String.valueOf(ht.get("CAR_MNG_ID")), a_bean.getAccid_dt());
			InsurBean ins = ai_db.getIns(String.valueOf(ht.get("CAR_MNG_ID")), ins_st);
			ins_com_nm = ai_db.getInsComNm(String.valueOf(ht.get("CAR_MNG_ID")), ins_st);
			
			if(a_bean.getOur_ins().equals("")){
				a_bean.setOur_ins(ins_com_nm);
			}
			
			//������� ��������
			OtAccidBean oa_r [] = as_db.getOtAccid( String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("ACCID_ID")) );
			
			//�ڱ��ü���
			OneAccidBean oe_r [] = as_db.getOneAccid(String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("ACCID_ID")));
			
			//����/����(��å��)
			ServiceBean s_r [] = as_db.getServiceList(String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("ACCID_ID")));
			
			//����û����������Ʈ
			MyAccidBean my_r [] = as_db.getMyAccidList(String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("ACCID_ID")));
			
			//�ܱ�������
			RentContBean rc_bean = rs_db.getRentContCaseAccid(String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("ACCID_ID")));
			
			//������������
			Hashtable reserv = rs_db.getCarInfo(rc_bean.getCar_mng_id());
		
			// ���� �� ��å�� ���� 
			int tot_sv_amt = 0;
			int tot_sv_req_amt = 0;
			int tot_sv_pay_amt = 0;
			int tot_accid_amt = 0;
			int attach_serv_cnt = 0;  // ������ ��ϰ��� 
			int chk_cnt =0;
			for(int ii=0; ii<s_r.length; ii++){
				s_bean2 = s_r[ii];
				if(!s_bean2.getNo_dft_yn().equals("Y") && !s_bean2.getServ_st().equals("7")){ //�縮�� 
					tot_sv_amt 		+= s_bean2.getTot_amt();
				}
				
				tot_accid_amt 	+= s_bean2.getTot_amt();
				tot_sv_req_amt 	+= s_bean2.getCust_amt();
				tot_sv_pay_amt 	+= s_bean2.getExt_amt();
				if(s_bean2.getDly_amt()>0){
					tot_sv_req_amt  += s_bean2.getDly_amt();
					tot_sv_pay_amt 	+= s_bean2.getDly_amt();
				}
				if(s_bean2.getCls_amt()>0){
					tot_sv_req_amt  += s_bean2.getCls_amt();
					tot_sv_pay_amt 	+= s_bean2.getCls_amt();
				}
				
				String  content_code = "SERVICE";
				String content_seq  = s_bean2.getCar_mng_id()+""+s_bean2.getServ_id();

				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
			//	attach_vt_size = attach_vt.size();	
				
				attach_serv_cnt = attach_vt.size();						
			}

			if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("3")){//����,�ֹ�
				if(oa_r.length == 0){//�������� ��ϰǼ�
				 chk_cnt += 1;		
				}
			}
					
			if(!rc_bean.getCar_mng_id().equals("")){//�������񽺰� �ִ�
				if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("3")){//����,�ֹ�			
							if(my_r.length == 0){
								 chk_cnt += 1;					
							}					
				 }
			}
				
			if(!a_bean.getAccid_st().equals("1") && a_bean.getDam_type4().equals("Y")){//����
				if(s_r.length == 0) {
					 chk_cnt += 1;	
				}
			}
				
	
			if(!String.valueOf(cont.get("CAR_ST")).equals("2") && ins.getCon_f_nm().equals("�Ƹ���ī") && tot_sv_amt > 0 && tot_sv_req_amt == 0) {
					if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("2") || a_bean.getAccid_st().equals("3") || a_bean.getAccid_st().equals("8")){//����,����,�ֹ�,�ܵ�
						if(a_bean.getAccid_st().equals("1") && a_bean.getOur_fault_per()==0 ){//100% ���� - ��å�ݾ���.
						}else{
				 			chk_cnt += 1;						
						}	
					}
			}

			// ���ػ���� ��� 1���� ���� �ʼ�  --�� --������  �Է�
			if(a_bean.getAccid_st().equals("1") && tot_sv_amt == 0 ){//���ػ�� 1���� �Է�>
				 chk_cnt += 1;	
			}
				
				// ������ ��ĵ - ���񳻿��� ���� ��� 	
		    if( tot_accid_amt > 0   &&  attach_serv_cnt  == 0   ){
					if(a_bean.getAccid_st().equals("1") && a_bean.getOur_fault_per()==0 ){//100% ���� - ��å�ݾ���.
					}else{  
						if(!s_bean.getRep_cont().equals("��å�� ��û����")){
								 chk_cnt += 1;						
						}			
				  	}
			}
						
			//	<!-- ������ û���� ���� ���� Ȯ��   
		 // 	if(tot_my_req_amt >0  && my_accid_cnt > 0   ){	  
		  //		 chk_cnt += 1;				   
		//	}
%>
		<tr>
		   <input type='hidden' name="chk_cnt" value="<%=chk_cnt%>">	
		       
		    <%if(!String.valueOf(ht.get("DOC_NO")).equals("") && String.valueOf(ht.get("USER_DT2")).equals("") && mng_mode.equals("A")){%>   
		    <td width='30' align='center'><input type="checkbox" name="ch_cd" value="<%=i%>^<%=chk_cnt%>^<%=ht.get("DOC_NO")%>^" 
				  <% if (  String.valueOf(ht.get("ACCID_ST")).equals("1") ) {//�����ΰ�� 
					if ( AddUtil.parseInt(String.valueOf(ht.get("OUR_FAULT_PER"))) > 0) { %>
					disabled
				<%	}
				} else if (  String.valueOf(ht.get("ACCID_ST")).equals("2") ) {//�����ΰ�� 
					if ( AddUtil.parseInt(String.valueOf(ht.get("OUR_FAULT_PER"))) < 100 ) { %>
						disabled
				<%	}
				} else if (  String.valueOf(ht.get("ACCID_ST")).equals("3") ) {//�ֹ��ΰ�� 
					if ( AddUtil.parseInt(String.valueOf(ht.get("OUR_FAULT_PER"))) < 1 ) {  %>
					disabled
				<%	}	
				} else  {//�ܵ��ΰ��   //���� ���� 
				
					if ( AddUtil.parseInt(String.valueOf(ht.get("OUR_FAULT_PER"))) < 100) { %>
					disabled
				<%	}
				} %> ></td>
		        <%}else{%>
		          <td width='30' align='center'>&nbsp;</td>
		     <%}%>          
		    <td  width='30' align='center'><%=i+1%></td>		
		    <td  width='60' align='center'><%=ht.get("BIT")%></td>
		    <td  width='130' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("ACCID_DT")))%></td>
		    <td  width='170'>&nbsp;
			<%if(!String.valueOf(ht.get("RES_ST")).equals("")){%>
			    [<%=ht.get("RES_ST")%>]
			<%}%>
			<%if(String.valueOf(ht.get("RES_ST")).equals("")){%>
			<!--    <a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"> -->
			        <span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 12)%></span>
			<!--    </a> -->
			<%}else{%>
			<!--  <a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"> -->
				<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span>
			<!--    </a> -->
			<%}%>	
		    </td>
		    <td  width='80' align='center'><%=ht.get("CAR_NO")%></td>
		    <td  width='120' align='center'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 11)%></td>
		    <td  width='50' align='center'><%=ht.get("BUS_NM2")%></td>					
		</tr>
<%
		}
%>
	    </table>
		</td>
		<td class='line' width='590'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>			
				<tr>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USER_DT1")))%></td>
					<td  width='60' align='center'>
					  <!--�����-->
					  <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
					  <a href="javascript:parent.doc_action('1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>','<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a>
					  <%}else{%>
					  <a href="javascript:parent.doc_action('1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>','<%=ht.get("DOC_NO")%>');"><%=ht.get("USER_NM1")%></a>
					  <%}%>
					  </td>
					<td  width='60' align='center'>
					  <!--������-->
					  <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && !String.valueOf(ht.get("USER_ID2")).equals("XXXXXX")){%>
					  <%	if(String.valueOf(ht.get("USER_DT2")).equals("") && !String.valueOf(ht.get("USER_ID2")).equals("XXXXXX")){%>
					  <a href="javascript:parent.doc_action('2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>','<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>					  
					  <%	}else{%>
					  <a href="javascript:parent.doc_action('2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>','<%=ht.get("DOC_NO")%>');"><%=ht.get("USER_NM2")%></a>
					  <%	}%>
					  <%}else{%>-<%}%></td>
					<td  width='70' align='center'><%=ht.get("ACCID_ST_NM")%>
					<% if ( String.valueOf(ht.get("ASSET_ST")).equals("Y")  ) {%><font color=red>&nbsp;����</font> <%}%>
					</td>
					<td  width='60' align='center'><%=ht.get("OUR_FAULT_PER")%></td>					
					<td  width='60' align='center'><%=Math.abs(AddUtil.parseInt(String.valueOf(ht.get("OUR_FAULT_PER")))-100)%></td>
					<td  width='200'>&nbsp;<span title='<%=ht.get("ACCID_ADDR")%>'><%=Util.subData(String.valueOf(ht.get("ACCID_ADDR")), 16)%></span></td>									
				</tr>
<%
		}
%>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='670' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.
					<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='590'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
