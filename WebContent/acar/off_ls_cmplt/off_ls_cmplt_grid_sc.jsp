<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "acar.util.*, acar.offls_cmplt.*"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*, acar.user_mng.*"%>
<%@ page import="org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<jsp:useBean id="olcBean" class="acar.offls_cmplt.Offls_cmpltBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 3; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String jobjString = "";
	
	if(!ref_dt1.equals("") && ref_dt2.equals("")) ref_dt2 = ref_dt1;
	
	Offls_cmpltBean olcb[] = olcD.getCmplt_lst(dt, ref_dt1, ref_dt2, gubun, gubun1, gubun_nm, brch_id, s_au);
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	/*
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt5 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	
	float avg_per1 = 0;
	float avg_per2 = 0;
	float avg_per3 = 0;
	float avg_per4 = 0;
	float avg_per5 = 0;
	float avg_per6 = 0;
	float avg_per7 = 0;
	
	//grid �߰�
	float avg_per_con = 0;
	float avg_per_purch = 0;
	float avg_per_exp = 0;
	float avg_per_cha1 = 0;
	float avg_per_cha2 = 0;
	float repair_avg_con = 0;
	float avg_per_cha1_4 = 0;
	float avg_per_cha2_4 = 0;	
	float avg_per_cha1_2 = 0;
	float avg_per_cha2_2 = 0;	
	float avg_per_cha1_3 = 0;
	float avg_per_cha2_3 =0;
	*/
	
	//����縮������������� ���ϱ�
	float use_per1 = 0;
	float use_per2 = 0;
	float use_per3 = 0;
	float use_per4 = 0;
	
	float use_cnt1 = 0;
	float use_cnt2 = 0;
	float use_cnt3 = 0;
	float use_cnt4 = 0;
	

	int k =  0;
	
	if(olcb.length >= 0 ){
		
		int vt_size = olcb.length;
		
		jobjString = "data={ rows:[ ";
		
		for(int i=0; i< olcb.length; i++){
			
			if(i != 0 ){
				jobjString += ",";
			}	
			
			olcBean = olcb[i];
			String seq = olcD.getAuction_maxSeq(olcBean.getCar_mng_id());
			
			int cSum 	= olcBean.getCar_cs_amt() + olcBean.getCar_cv_amt() + olcBean.getOpt_cs_amt() + olcBean.getOpt_cv_amt() + olcBean.getClr_cs_amt() + olcBean.getClr_cv_amt();
			int fSum 	= olcBean.getCar_fs_amt() + olcBean.getCar_fv_amt() + olcBean.getSd_cs_amt()  + olcBean.getSd_cv_amt()  - olcBean.getDc_cs_amt()  - olcBean.getDc_cv_amt();
			int opt_price	= olcBean.getOpt_cs_amt()+olcBean.getOpt_cv_amt();
			
			double hppr 		= olcBean.getHppr();
			double nakpr 		= olcBean.getNak_pr();
			double o_s_amt 		= olcBean.getO_s_amt();
			double hp_s_cha_amt	= olcBean.getHp_s_cha_amt();
			double hp_accid_amt	= olcBean.getHp_accid_amt();
			
			double hp_c_per 	= (nakpr*100)/cSum;
			double hp_f_per 	= (nakpr*100)/fSum;
			double hp_s_per 	= 0;
			double hp_s_cha_per 	= 0;
			double hp_c_cha_per 	= 0;
			double abs_hp_s_cha_per = 0;
			double abs_hp_c_cha_per = 0;
			double hp_accid_c_per 	= 0;
			//�����ݾ� ���밪
			double abs_hp_s_cha_amt = 0;
			long   l_abs_hp_s_cha_amt = 0;
			
			if(o_s_amt>0){
				abs_hp_s_cha_amt = olcBean.getHp_s_cha_amt()>0?olcBean.getHp_s_cha_amt():-olcBean.getHp_s_cha_amt();
				l_abs_hp_s_cha_amt = olcBean.getHp_s_cha_amt()>0?olcBean.getHp_s_cha_amt():-olcBean.getHp_s_cha_amt();
				hp_s_per 	= (nakpr*100)/o_s_amt;
				hp_s_cha_per 	= (hp_s_cha_amt*100)/o_s_amt;
				hp_c_cha_per 	= (hp_s_cha_amt*100)/cSum;
				abs_hp_s_cha_per= (abs_hp_s_cha_amt*100)/o_s_amt;
				abs_hp_c_cha_per= (abs_hp_s_cha_amt*100)/cSum;
								
			}
			if(hp_accid_amt>0){
				hp_accid_c_per 	= (hp_accid_amt*100)/cSum;
			}
			
			float use_per = AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_s_per),2));
						
			if(olcBean.getActn_id().equals("000502")){//��ȭ-����۷κ�(��)
				use_cnt1++;
				use_per1 = use_per1 + use_per;
			}else if(olcBean.getActn_id().equals("013011")){//�д�-����۷κ�(��)
				use_cnt2++;
				use_per2 = use_per2 + use_per;
			}else if(olcBean.getActn_id().equals("022846")){//��ȭ����ũ 013222-> 20150515 (��)����Ƽ��Ż 022846
				use_cnt3++;
				use_per3 = use_per3 + use_per;
			}else if(olcBean.getActn_id().equals("011723")||olcBean.getActn_id().equals("020385")){//(��)�����ڵ������ -> �������̼�ī �ֽ�ȸ��
				use_cnt4++;
				use_per4 = use_per4 + use_per;
			}	
			
/*								
			total_amt1 	= total_amt1  + AddUtil.parseLong(String.valueOf(cSum));//avg_per_con, avg_per_cha2, repair_avg_con	, avg_per_cha2_3
			total_amt2 	= total_amt2  + AddUtil.parseLong(String.valueOf(fSum));//avg_per_purch			
			total_amt3 	= total_amt3  + AddUtil.parseLong(String.valueOf(olcBean.getO_s_amt()));//avg_per_exp, avg_per_cha1, avg_per_cha1_3
			total_amt5 	= total_amt5  + AddUtil.parseLong(String.valueOf(olcBean.getNak_pr()));//avg_per_con, avg_per_purch, avg_per_exp
			total_amt11	= total_amt11 + AddUtil.parseLong(String.valueOf(olcBean.getHp_accid_amt()));//repair_avg_con					
			total_amt12	= total_amt12 + AddUtil.parseLong(String.valueOf(l_abs_hp_s_cha_amt));//avg_per_cha1, avg_per_cha2
			total_amt13	= total_amt13 + AddUtil.parseLong(String.valueOf(olcBean.getHp_s_cha_amt()));//avg_per_cha1_3, avg_per_cha2_3
						
			avg_per1 = avg_per1 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_c_per),2));
			avg_per2 = avg_per2 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_f_per),2));
			avg_per3 = avg_per3 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_s_per),2));
			avg_per4 = avg_per4 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(abs_hp_s_cha_per),2));//avg_per_cha1_2
			avg_per5 = avg_per5 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(abs_hp_c_cha_per),2));//avg_per_cha2_2
			avg_per6 = avg_per6 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_s_cha_per),2));//avg_per_cha1_4
			avg_per7 = avg_per7 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(hp_c_cha_per),2));//avg_per_cha2_4
			
			
			//grid �߰�
			avg_per_con = AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt5))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2);//�Ű�(����)-�Һ��ڰ� ��� : ���� ���밪 �ݿ� - ���(��ձݾ� �� ��ձݾ����� ���)
			avg_per_purch = AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt5))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt2))/vt_size)*100,2)	;//�Ű�(����)-���԰� ��� : ���� ���밪 �ݿ� - ���(��ձݾ� �� ��ձݾ����� ���)		
			avg_per_exp = AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt5))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt3))/vt_size)*100,2);//�Ű�(����)-�������� ��� : ���� ���밪 �ݿ� - ���(��ձݾ� �� ��ձݾ����� ���)
			avg_per_cha1 = AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt12))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt3))/vt_size)*100,2);//�Ű�(����)-����%(�������� ����) : ���� ���밪 �ݿ� - ���(��ձݾ� �� ��ձݾ����� ���)
			avg_per_cha2 = AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt12))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2);//�Ű�(����)-����%(�Һ��ڰ� ����) : ���� ���밪 �ݿ� - ���(��ձݾ� �� ��ձݾ����� ���)
			repair_avg_con = AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt11))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2);//��������-�Һ��ڰ� ��� : ���� ���밪 �ݿ� - ���(��ձݾ� �� ��ձݾ����� ���)

			avg_per_cha1_2 = AddUtil.parseFloatCipher(avg_per4/vt_size,2);//�Ű�(����)-����%(�������� ����) : ���� ���밪 �ݿ� - ���(������� ���)
			avg_per_cha2_2 = AddUtil.parseFloatCipher(avg_per5/vt_size,2);//�Ű�(����)-����%(�Һ��ڰ� ����) : ���� ���밪 �ݿ� - ���(������� ���)
			
			avg_per_cha1_4 = AddUtil.parseFloatCipher(avg_per6/vt_size,2);//�Ű�(����)-����%(�������� ����) : ���� ��ȣ �ݿ� - ���(������� ���)
			avg_per_cha2_4 = AddUtil.parseFloatCipher(avg_per7/vt_size,2);//�Ű�(����)-����%(�Һ��ڰ� ����) : ���� ��ȣ �ݿ� - ���(������� ���)
			
			avg_per_cha1_3 = AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt13))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt3))/vt_size)*100,2);//�Ű�(����)-����%(�������� ����) : ���� ��ȣ �ݿ� - ������(��ձݾ� �� ��ձݾ����� ���)
			avg_per_cha2_3 = AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt13))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2);//�Ű�(����)-����%(�Һ��ڰ� ����) : ���� ��ȣ �ݿ� - ������(��ձݾ� �� ��ձݾ����� ���)
*/

			k =  i+1;	 	 	
			
			jobjString +=  " { id:" + k + ",";
			
			jobjString +=  "data:[\" \",";//üũ�ڽ�0
			
	 	 	if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("�Ű�������",ck_acar_id)){
	 	 		jobjString +=  "\""  +  k + "^javascript:view_detail_s(&#39;"+auth_rw+"&#39;, &#39;"+olcBean.getCar_mng_id()+"&#39;, &#39;"+seq+"&#39;);^_self\",";//����1
	 	 	} else {
	 	 		jobjString +=  "\""  +  k + "^javascript:on_print(&#39;"+olcBean.getCar_mng_id()+"&#39);^_self\",";//����1
	 	 	}
	 	 	
	 	 	if(olcBean.getA_cnt() < 1 ){//���ذ�¾���
		 	 	jobjString +=  "\"" +olcBean.getCar_no() + " " + olcBean.getSss()+"^javascript:view_detail(&#39;"+auth_rw+"&#39;, &#39;"+olcBean.getCar_mng_id()+"&#39;, &#39;"+seq+"&#39;);^_self\",";//������ȣ2
	 	 	} else {//��������, <font color="#ff8200">
		 	 	jobjString +=  "\"" +olcBean.getCar_no() + " " + olcBean.getSss()+"^javascript:view_detail(&#39;"+auth_rw+"&#39;, &#39;"+olcBean.getCar_mng_id()+"&#39;, &#39;"+seq+"&#39;);^_self\",";//������ȣ2
	 	 	}
	 	 	
	 	 	jobjString +=  "\"" +olcBean.getCar_jnm()+ " "+olcBean.getCar_nm()+"\",";//����3
	 	 	jobjString +=  "\""+olaD.getActn_nm(olcBean.getActn_id()) + "\",";//�����4
	 	 	jobjString +=  "\""+AddUtil.ChangeDate2(olcBean.getActn_dt()) + "\",";//�������5
	 	 	jobjString +=  "\""+AddUtil.ChangeDate2(olcBean.getInit_reg_dt())  + "\",";//���ʵ����6
	 	 	
	 		jobjString +=  "\""+AddUtil.ChangeDate2(olcBean.getCont_dt())  + "\",";// ����� 40  20180213 �߰� 
	 		jobjString +=  "\""+AddUtil.ChangeDate2(olcBean.getJan_pr_dt())  + "\",";//�Ա��� 41
	 	 	
	 	 	jobjString +=  "\""+cSum + "\",";//�Һ��ڰ���7
	 	 	jobjString +=  "\""+fSum + "\",";//���԰���8
	 	 	jobjString += "\""+ olcBean.getHppr() + "\",";//�����9
	 	 	jobjString += "\""+ olcBean.getO_s_amt() + "\",";//��������10
	 	 	jobjString += "\""+ olcBean.getNak_pr() + "\",";//������11
	 	 	jobjString +=  "\""+String.valueOf(hp_c_per) + "\",";//�Һ��ڰ� ���12
	 		jobjString += "\""+String.valueOf(hp_f_per) + "\",";//���԰� ���13
	 	 	jobjString += "\""+String.valueOf(hp_s_per) + "\",";//�������� ���14
	 		jobjString +=  "\""+olcBean.getHp_s_cha_amt() + "\",";//�����ݾ�15
	 		jobjString +=  "\""+String.valueOf(hp_s_cha_per) + "\",";//����%(�������� ����)16
	 		jobjString +=  "\""+String.valueOf(hp_c_cha_per) + "\",";//����%(�Һ��ڰ� ����)17
	 		jobjString +=  "\""+olcBean.getCar_old_mons() + "\",";//����18
	 		
	 		if(olcBean.getKm().equals("")) {
		 		jobjString +=  "\""+olcBean.getToday_dist() + "\",";//����Ÿ�19
	 		} else {
	 			jobjString +=  "\""+olcBean.getKm() + "\",";//����Ÿ�19
	 		}
	 		
	 		jobjString +=  "\""+olcBean.getActn_jum() + "\",";//����� ����20
	 		jobjString +=  "\""+olcBean.getPark_nm() + "\",";//������ ��ġ21
	 		
	 		if(olcBean.getAccident_yn().equals("1")) {
	 			jobjString +=  "\"��\",";//�������22
	 		} else {
	 			jobjString +=  "\"-\",";//�������22
	 		}
	 			
	 		jobjString +=  "\""+olcBean.getHp_accid_amt() + "\",";//�������� - �����ݾ�23
	 		jobjString +=  "\""+AddUtil.parseFloat(String.valueOf(hp_accid_c_per))+"\",";//�������� - �Һ��ڰ� ���24
	 		jobjString +=  "\""+olcBean.getComm1_tot() + "\",";//�Ű������� - ����������25
	 		
	 		if(AddUtil.parseDecimal(olcBean.getOut_amt()).equals("0")||AddUtil.parseDecimal(olcBean.getOut_amt()).equals("")||AddUtil.parseDecimal(olcBean.getOut_amt()).equals("null")) {	 			
	 			jobjString +=  "\""+olcBean.getComm2_tot() + "\",";//�Ű������� - ��ǰ������26
	 		} else {
	 			jobjString +=  "\"0\",";//�Ű������� - ��ǰ������26
	 		}
	 		
	 		jobjString +=  "\""+olcBean.getOut_amt() + "\",";//�Ű������� - ����ǰ������27
	 		jobjString +=  "\""+olcBean.getComm3_tot() + "\",";//�Ű������� - ����Ź�۴��28
	 		//jobjString +=  ",";//�Ű������� - �հ�28 : �׸��� ��ü �������� �հ� ���
	 		jobjString +=  "\""+olcBean.getComm_tot() + "\",";//�Ű������� - �հ�29
	 		jobjString +=  "\""+olcBean.getSui_nm() + "\",";//������30
	 		jobjString += "\""+olcBean.getOpt() + "\",";//���û��31
	 		jobjString += "\""+opt_price + "\",";//���û�簡32
	 		jobjString += "\""+AddUtil.parseDecimal(olcBean.getDpm()) + "\",";//��ⷮ33
	 		
	 		jobjString += "\""+c_db.getNameByIdCode("0039", "", olcBean.getFuel_kd()) + "\",";//����34
	 			 		
	 		jobjString += "\""+ olcBean.getColo() + "\",";//����35
	 		jobjString += "\""+ olcBean.getIn_col() + "\",";//�������36
	 		jobjString += "\""+ olcBean.getJg_code() + "\",";//�����ڵ�37 
	 		jobjString += "\""+ olcBean.getIns_com_nm() + "\",";//����-�����38

	 		if(olcBean.getReq_dt().equals("")) {
	 			jobjString += "\"<font color=red>��û��</font>\",";;//����-û������39, <font color=red>��û��</font>
	 		} else {
	 			jobjString += "\"û��\",";;//����-û������39
	 		}

	 		jobjString += "\""+ olcBean.getCar_mng_id()+ "\"]";//�ڵ��� ���� ��ȣ40
	 		
	 	 	jobjString += "}";
		}
		jobjString += "]};";
	}
%>
<!DOCTYPE html>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">

<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<!--Grid-->

<style type="text/css">
	html, body {height: 93%;	}
	input.whitenum {text-align: right;  border-width: 0; }
</style>


<script>

function view_detail(auth_rw,car_mng_id, seq)
{
	var gubun = document.form1.gubun.value;
	var gubun_nm = document.form1.gubun_nm.value;
	var url = "?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&gubun="+gubun+"&gubun_nm="+gubun_nm+"&seq="+seq;
	parent.parent.d_content.location.href ="/acar/off_ls_cmplt/off_ls_cmplt_sc_in_detail_frame.jsp"+url;
}

function view_detail_s(auth_rw,car_mng_id, seq)
{
	var SUBWIN= "/acar/off_ls_jh/off_ls_info.jsp?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&seq="+seq;
	window.open(SUBWIN, "View_OFFLS", "left=50, top=50, width=400, height=730, resizable=yes, scrollbars=yes");
}

function on_print(car_mng_id)
{

	var SUBWIN="/acar/off_ls_jh/off_ls_jh_print.jsp?car_mng_id="+car_mng_id;	
	window.open(SUBWIN, "on_print", "left=100, top=100, width=800, height=800, scrollbars=yes");
}

function excel_reg(){
	var fm = document.form1;
	fm.target = "_blank";
	fm.action = "in_excel.jsp";
	fm.submit();
}

<%=jobjString%>

var myGrid;

function parsingGridData(){
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//��0-40��(41��)
	myGrid.setHeader("#master_checkbox,����,������ȣ,����,�����,�������,���ʵ����,�����,�Ա���,�Һ��ڰ���,���԰���,�����,��������,�Ű�(����),#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,����,����<br>�Ÿ�,�����<br>����,��������ġ,���<br>����,��������,#cspan,�Ű�������,#cspan,#cspan,#cspan,#cspan,������,���û��,���û�簡,��ⷮ,����,����,�������,�����ڵ�,����,#cspan,");
	myGrid.setInitWidths("35,35,70,170,85,85,85,85,85,100,100,100,100,90,70,70,70,90,85,75,55,65,60,80,50,95,70,85,70,85,80,85,100,170,90,70,50,90,80,70,95,90,0");
	myGrid.setColSorting("str,int,str,str,str,str,str,str,str, int,int,int,int,int,int,int,int,int,int,int,int,int,str,str,str,int,int,int,int,int,int,int,str,str,int,int,str,str,str,int,str,str,int");
	myGrid.setColTypes("ch,link,link,ro,ro,ro,ro,ro,ro,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ro,ro,ro,ron,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ro,ro,ro,ron,ro,ro,ron");
	myGrid.attachHeader("#rspan,#rspan,#text_filter,#text_filter,#select_filter,#select_filter,#select_filter,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,������,�Һ��ڰ�<br>���,���԰�<br>���,����<br>������<br>���,�����ݾ�,����%<br>(��������<br>����),����%<br>(�Һ��ڰ�<br>����),#rspan,#rspan,#rspan,#select_filter,#select_filter,�����ݾ�,�Һ��ڰ�<br>���,����<br>������,��ǰ<br>������,����ǰ<br>������,����<br>Ź�۴��,�հ�,#text_filter,#text_filter,#rspan,#rspan,#select_filter,#text_filter,#select_filter,#select_filter,�����,û������,#rspan");
	myGrid.setColAlign("center,center,center,center,center,center,center,center,center, right,right,right,right,right,right,right,right,right,right,right,center,right,center,center,center,right,right,right,right,right,right,right,center,center,right,center,center,center,center,center,center,center,center");
	myGrid.enableTooltips("true,false,false,true,true,false,false,false,false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,true,false,false,false,true,false,false,true,false,false");
	myGrid.setColumnHidden(42,true);
	myGrid.setNumberFormat("0,000",9);
	myGrid.setNumberFormat("0,000",10);
	myGrid.setNumberFormat("0,000",11);
	myGrid.setNumberFormat("0,000",12);
	myGrid.setNumberFormat("0,000",13);
	myGrid.setNumberFormat("0,000.00%",14);
	myGrid.setNumberFormat("0,000.00%",15);
	myGrid.setNumberFormat("0,000.00%",16);
	myGrid.setNumberFormat("0,000",17);
	myGrid.setNumberFormat("0,000.00%",18);
	myGrid.setNumberFormat("0,000.00%",19);
//	myGrid.setNumberFormat("0,000",20);		
	myGrid.setNumberFormat("0,000",21);		//����Ÿ� ���� fmsó�� ����(sekim)
	myGrid.setNumberFormat("0,000",25);
	myGrid.setNumberFormat("0,000.00%",26);
	myGrid.setNumberFormat("0,000",27);
	myGrid.setNumberFormat("0,000",28);
	myGrid.setNumberFormat("0,000",29);
	myGrid.setNumberFormat("0,000",30);
	myGrid.setNumberFormat("0,000",31);
	myGrid.setNumberFormat("0,000",34);

	myGrid.attachEvent("onXLE",function(){  
		if (!myGrid.getRowsNum())	{
			document.getElementById("a_1").style.display="none"; 
			alert('�ش� ������ �����ϴ�');
		} else {
			document.getElementById("a_1").style.display="none"; 
		}
	});	
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;
	
	myGrid.attachEvent("onCheckbox",doOnCheck);

	/* myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,#cspan,#cspan,�հ�,#cspan,#cspan,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,,#stat_total,,,,,,,,#stat_total,,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,#stat_total,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,#cspan,#cspan,�հ�,#cspan,#cspan,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,,#stat_total,,,,,,,,#stat_total,,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,#stat_total,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,#cspan,#cspan,���(��ձݾ� �� ��ձݾ����� ���),#cspan,#cspan,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,{#stat_multi_total_avg}7:11,{#stat_multi_total_avg}8:11,{#stat_multi_total_avg}10:11,#stat_average,{#stat_multi_total_avg}10:15,{#stat_multi_total_avg}7:15,,,,,,#stat_average,{#stat_multi_total_avg}7:23,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,,,#stat_average,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,#cspan,#cspan,���(������� ���),#cspan,#cspan,,,,,,#stat_average,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,#stat_average,,,,,#stat_average,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ���밪 �ݿ�,#cspan,#cspan,#cspan,�հ�,#cspan,#cspan,,,,,,,,,#stat_cha_total,,,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ���밪 �ݿ�,#cspan,#cspan,#cspan,���(��ձݾ� �� ��ձݾ����� ���),#cspan,#cspan,,,,,,,,,#stat_cha_average,{#stat_multi_total_avg_cha}10:15,,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ���밪 �ݿ�,#cspan,#cspan,#cspan,���(������� ���),#cspan,#cspan,,,,,,,,,,#stat_cha_average,#stat_cha_average,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]); */
	
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,#cspan,#cspan,�հ�,#cspan,#cspan,,,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,,#stat_total,,,,,,,,#stat_total,,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,#stat_total,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,#cspan,#cspan,���(��ձݾ� �� ��ձݾ����� ���),#cspan,#cspan,,,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,{#stat_multi_total_avg}9:13,{#stat_multi_total_avg}10:13,{#stat_multi_total_avg}12:13,#stat_average,{#stat_multi_total_avg}12:17,{#stat_multi_total_avg}9:17,,,,,,#stat_average,{#stat_multi_total_avg}9:25,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,,,#stat_average,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,#cspan,#cspan,���(������� ���),#cspan,#cspan,,,,,,,,#stat_average,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,#stat_average,,,,,#stat_average,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ���밪 �ݿ�,#cspan,#cspan,#cspan,�հ�,#cspan,#cspan,,,,,,,,,,,#stat_cha_total,,,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ���밪 �ݿ�,#cspan,#cspan,#cspan,���(��ձݾ� �� ��ձݾ����� ���),#cspan,#cspan,,,,,,,,,,,#stat_cha_average,{#stat_multi_total_avg_cha}12:17,,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ���밪 �ݿ�,#cspan,#cspan,#cspan,���(������� ���),#cspan,#cspan,,,,,,,,,,,,#stat_cha_average,#stat_cha_average,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	
	myGrid.splitAt(7);
	//myGrid.enableBlockSelection();
    myGrid.enableMathEditing(true);
    myGrid.enableColumnMove(true);      
    myGrid.enableSmartRendering(false);
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    myGrid.parse(data,"json");	    
    
}

function onKeyPressed(code,ctrl,shift){
	if(code==67&&ctrl){
		if (!myGrid._selectionArea) return alert("You need to select a block area in grid first");
			myGrid.setCSVDelimiter("\t");
			
			myGrid.copyBlockToClipboard()
		}
		if(code==86&&ctrl){
			myGrid.setCSVDelimiter("\t");
			myGrid.pasteBlockFromClipboard()
		}
	return true;
}

function doOnCheck(rowId, celllnd, state){

  // �ڵ��� ���� ��ȣ�� parameter value�� �Ѱܾ��ϱ⿡ Ȥ�� �׸��� �����Ǹ� �ش� ���� �������־�� ��. 
    var selectedValue = myGrid.cells(rowId,42).getValue();
    
  //  alert( myGrid.cells(rowId,42).getValue());  //20180305 ���� 
      
    var value = "";
    var cnt = parseInt($('#selectValueList').val());
    
    if(state == true){ //üũ�ڽ� check �Ǿ�����
        $('#selectValueList').val(cnt+1);
        $('#gridForm').append("<input type='hidden' name='pr' value='"+selectedValue+"' id='"+selectedValue+"'/>");

    }else{ //üũ�ڽ� check �����Ǹ�
        $('#selectValueList').val(cnt-1);
        $('#'+selectedValue).remove();
    }
}

</script>

</head>
<body leftmargin="15" onload="javascript:parsingGridData();">
<form name='form1' method='post' target='d_content' action='' id="gridForm">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<input type="hidden" name="selectValueList" id="selectValueList" value="0"/>
<table border="0" cellspacing="0" cellpadding="0" width=100% height="35px">
	<tr>
		<td align=''>
			<a href="javascript:myGrid.toExcel('/grid-excel/generate');"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			<a href="javascript:excel_reg();"><img src=/acar/images/center/button_excel_dr.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
          <td align="right" style="margin-right:5px; font-size: 9pt;">
				* ��� �������������:
				[����۷κ�-��ȭ]	<input type='text' name='avg_per1' size='4' class='whitenum'>%&nbsp;
				[����۷κ�-�д�]	<input type='text' name='avg_per2' size='4' class='whitenum'>%&nbsp;
				[�������̼�ī �ֽ�ȸ��]	<input type='text' name='avg_per4' size='4' class='whitenum'>%&nbsp;		
				[�Ե���Ż]		<input type='text' name='avg_per3' size='4' class='whitenum'>%&nbsp;            
        </td>        
    </tr>
</table>
</form>
<div id="gridbox" style="width:100%;height:100%; margin: 5px 0 5px 0;"></div>
<table border="0" cellspacing="0" cellpadding="0" width=100% height="25px">
    <tr> 
        <td width="*" align="left" style="font-size: 9pt;">
            * �� �Ǽ� : <span id="gridRowCount">0</span>�� 
        </td>
        <td width="10%">
			<div id="a_1" style="color:red;">Loading</div>
        </td>
        <td width="80%" align="right" style="font-size: 9pt;">
        	<span>*������ȣ�� Y�� �ڻ�������. * �������� : 20150512 �������� �縮��������, 20150512 ���ʹ� �������� ��갪</span>
        </td>
    </tr>    
</table>
<script language='javascript'>
<!--
	document.form1.avg_per1.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per1/use_cnt1), 2)%>';
	document.form1.avg_per2.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per2/use_cnt2), 2)%>';
	document.form1.avg_per3.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per3/use_cnt3), 2)%>';
	document.form1.avg_per4.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per4/use_cnt4), 2)%>';
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>