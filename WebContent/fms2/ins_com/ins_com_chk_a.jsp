<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.insur.*, acar.cont.*, acar.offls_sui.*, acar.cls.*, acar.credit.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
		
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int    size = request.getParameter("size")==null?0:Util.parseInt(request.getParameter("size"));
	

	String vid[] 	= request.getParameterValues("ch_cd");	
	int vid_size = vid.length;
	
	String chk_cont[]	 = new String[vid_size];
	
	String vid_num		= "";
	String reg_code 	= "";
	String seq 	= "";
	int    idx = 0;
	int    count = 0;
	int flag = 0;
	
	out.println(size);
	out.println(vid_size);
	
	
%>

<html>
<head>
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>

</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>

	var fm = parent.document.form1;
	
<%
	for(int i=0;i < vid_size;i++){
	
		vid_num = vid[i];
		
		int s=0; 
		String app_value[] = new String[7];
		if(vid_num.length() > 0){
			StringTokenizer st = new StringTokenizer(vid_num,"/");
			while(st.hasMoreTokens()){
				app_value[s] = st.nextToken();
				s++;
			}
		}
		
		reg_code = app_value[0];
		seq = app_value[1];
		idx = AddUtil.parseInt(app_value[2]);
		
		chk_cont[i] = "";
		
		InsurExcelBean iec_bean = ic_db.getInsExcelCom(reg_code, seq);
		
		
		if(iec_bean.getUse_st().equals("등록")){
		
			if(iec_bean.getGubun().equals("가입")){
				//cont 해지점검
				ContBaseBean base = a_db.getCont(iec_bean.getRent_mng_id(), iec_bean.getRent_l_cd());
				if(base.getUse_yn().equals("N")){
					chk_cont[i] = "계약해지";
				}
				if(chk_cont[i].equals("") && !base.getCar_mng_id().equals("")){
					//insur 기등록 확인
					InsurBean ins_bean = ai_db.getInsCase(base.getCar_mng_id(), ai_db.getInsSt(base.getCar_mng_id()));//보험정보
					if(!ins_bean.getCar_mng_id().equals("")){
						chk_cont[i] = "보험 기등록";
					}
				}
				//차대번호,차량번호,블랙박스 갱신
				if(chk_cont[i].equals("")){
					int u_cnt =0;
					Hashtable ht2 = ec_db.getRentBoardIns(iec_bean.getRent_mng_id(), iec_bean.getRent_l_cd());
					//중고차
					if(base.getCar_st().equals("2") && base.getCar_gu().equals("2")){
						ht2 = ec_db.getRentBoardInsAc(iec_bean.getRent_mng_id(), iec_bean.getRent_l_cd());
					}
					if(!String.valueOf(ht2.get("CAR_NO")).equals(iec_bean.getValue04())&&!String.valueOf(ht2.get("CAR_NO")).equals("")&&!String.valueOf(ht2.get("CAR_NO")).equals("null")){
						iec_bean.setValue04	(String.valueOf(ht2.get("CAR_NO")));
						u_cnt++;
					}
					if(!String.valueOf(ht2.get("CAR_NUM")).equals(iec_bean.getValue05())&&!String.valueOf(ht2.get("CAR_NUM")).equals("")&&!String.valueOf(ht2.get("CAR_NUM")).equals("null")){
						iec_bean.setValue05	(String.valueOf(ht2.get("CAR_NUM")));
						u_cnt++;
					}
					String b_com_model_nm = String.valueOf(ht2.get("B_COM_NM"))+"-"+String.valueOf(ht2.get("B_MODEL_NM"));
					if(!b_com_model_nm.equals(iec_bean.getValue11())&&!String.valueOf(ht2.get("B_COM_NM")).equals("")&&!String.valueOf(ht2.get("B_COM_NM")).equals("null")){
						iec_bean.setValue11	(b_com_model_nm);
						u_cnt++;
					}
					if(!String.valueOf(ht2.get("B_AMT")).equals(iec_bean.getValue12())&&!String.valueOf(ht2.get("B_AMT")).equals("")&&!String.valueOf(ht2.get("B_AMT")).equals("null")){
						iec_bean.setValue12	(String.valueOf(ht2.get("B_AMT")));
						u_cnt++;
					}
					if(!String.valueOf(ht2.get("B_SERIAL_NO")).equals(iec_bean.getValue13())&&!String.valueOf(ht2.get("B_SERIAL_NO")).equals("")&&!String.valueOf(ht2.get("B_SERIAL_NO")).equals("null")){
						iec_bean.setValue13	(String.valueOf(ht2.get("B_SERIAL_NO")));
						u_cnt++;
					}
					if(u_cnt >0){
						if(!ic_db.updateInsExcelCom(iec_bean)){
							flag += 1;
						}
					}
				}
			}
			
			if(iec_bean.getGubun().equals("갱신")){
			
				//매각(매입옵션 포함) 명의이전 등록 여부
				SuiBean sBean = olsD.getSui(iec_bean.getCar_mng_id());
				
				if(!sBean.getCar_mng_id().equals("") && !sBean.getMigr_dt().equals("") && AddUtil.parseInt(AddUtil.replace(iec_bean.getValue03(),"-","")) >= AddUtil.parseInt(sBean.getMigr_dt())){
					chk_cont[i] = "명의이전일 경과";
				}
				
				if(chk_cont[i].equals("")){
					Hashtable ht3 = a_db.getContViewUseYCarCase(iec_bean.getCar_mng_id());
					if(!iec_bean.getRent_l_cd().equals(String.valueOf(ht3.get("RENT_L_CD"))) && sBean.getCar_mng_id().equals("")){
						chk_cont[i] = "계약변경";
					}
				}
				
				//계약해지건인데 장기거래처일때
				ContBaseBean base = a_db.getCont(iec_bean.getRent_mng_id(), iec_bean.getRent_l_cd());
				
				if(chk_cont[i].equals("")){
					if(base.getUse_yn().equals("N") && !base.getCar_st().equals("2") && !iec_bean.getValue23().equals("(주)아마존카")){
						chk_cont[i] = "계약해지";
					}
				}
				
				if(chk_cont[i].equals("")){
					//해지의뢰정보
					ClsEtcBean cls = ac_db.getClsEtcCase(iec_bean.getRent_mng_id(), iec_bean.getRent_l_cd());
					if(!base.getUse_yn().equals("N") && !cls.getRent_l_cd().equals("")){
						chk_cont[i] = "계약해지의뢰";
					}
				}
				
				if(chk_cont[i].equals("")){
					//insur 기등록 확인
					InsurBean ins_bean = ai_db.getInsCase(base.getCar_mng_id(), ai_db.getInsSt(base.getCar_mng_id()));//보험정보
					if(AddUtil.replace(iec_bean.getValue03(),"-","").equals(ins_bean.getIns_start_dt()) && ins_bean.getIns_sts().equals("1")){
						chk_cont[i] = "보험 기등록";
					}
				}
				
			}
			
			
			if(iec_bean.getGubun().equals("배서")){
				
				ContBaseBean base = a_db.getCont(iec_bean.getRent_mng_id(), iec_bean.getRent_l_cd());
				
				//해지문서관리에서 요청
				if(iec_bean.getValue08().equals("임직원") && iec_bean.getValue11().equals("장기임차인 변경, 해지")){
					//해지의뢰정보
					ClsEtcBean cls = ac_db.getClsEtcCase(iec_bean.getRent_mng_id(), iec_bean.getRent_l_cd());
					if(!base.getUse_yn().equals("N") && cls.getRent_l_cd().equals("")){
						chk_cont[i] = "계약해지취소";
					}
				}else{
					
				}
				
				
				
			}
			
			if(iec_bean.getGubun().equals("해지")){
				
				//해지보험정보
				InsurClsBean cls = ai_db.getInsurClsCase(iec_bean.getCar_mng_id(), iec_bean.getIns_st());
				if(!cls.getCar_mng_id().equals("")){
					chk_cont[i] = "해지 기등록";
				}
			
			}
		}	
		
		
		if(size == 1){
			if(chk_cont[i].equals("")){
%>
				fm.chk_cont.value = '정상';
	
<%		}else{%>
	
				fm.chk_cont.value = '<%=chk_cont[i]%>';
				
<%	
			}
		}else{
			if(chk_cont[i].equals("")){
%>
				fm.chk_cont[<%=idx%>].value = '정상';
	
<%		}else{%>
	
				fm.chk_cont[<%=idx%>].value = '<%=chk_cont[i]%>';
				
<%	
			}
			
		}
		
	}
%>

</script>