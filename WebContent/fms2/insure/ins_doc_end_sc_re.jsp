<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*, acar.beans.*" %>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//if(1==1)return;
	
	String ch_cd[] 	= request.getParameterValues("ch_cd");
	String firm_nm[] 	= request.getParameterValues("firm_nm");
	String doc_no[] 	= request.getParameterValues("doc_no");
	String ch_dt[] 	= request.getParameterValues("ch_dt");
	String ch_e_dt[] 	= request.getParameterValues("ch_e_dt");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	InsurChangeBean d_bean = new InsurChangeBean();
	InsurChangeBean temp_bean = new InsurChangeBean();
	InsurChangeBean bean = new InsurChangeBean();
	CarScheBean cs_bean2 = new CarScheBean();
	CarScheBean cs_bean3 = new CarScheBean();
	CarScheBean cs_bean4 = new CarScheBean();
	DocSettleBean doc = new DocSettleBean();
	
	
	Vector ins_cha = new Vector();
	Vector vt = new Vector();
	//Hashtable ht = new Hashtable();
	
	int flag = 0;
	int count = 0;
	int dup_count = 0;
	String duple = "";
	String comple = "";
	int o_fee_amt = 0,	n_fee_amt = 0,	d_fee_amt = 0;

	String ch_st = "3" , ch_etc="보험변경 요청 원상복구";
	String sub ="", cont="" ;
	String user_id2 ="", user_id3="", user_id4="" ;
	String content_code ="", content_seq="" ;
	
	List<AttachedFile> attachList = new ArrayList<AttachedFile>();
	
	try{
		
		for(int i =0; i<ch_cd.length; i++){
			if(!ch_cd[i].equals("")){
				String reg_code = Long.toString(System.currentTimeMillis());
				//System.out.println(reg_code);
				
				//ins_change_doc
				d_bean = ins_db.getInsChangeDoc(ch_cd[i]);
				o_fee_amt = d_bean.getO_fee_amt();
				n_fee_amt = d_bean.getN_fee_amt();
				
				d_bean.setIns_doc_no(reg_code);
				
				d_bean.setO_fee_amt(n_fee_amt);
				d_bean.setN_fee_amt(o_fee_amt);
				d_bean.setD_fee_amt(o_fee_amt-n_fee_amt);
				
				d_bean.setUpdate_id(user_id);
				d_bean.setReg_id(user_id);
				d_bean.setCh_etc(ch_etc);
				d_bean.setCh_st(ch_st);
				d_bean.setCh_dt(d_bean.getCh_e_dt());
				
				count++;
				if(ins_db.getInsChangeDocCnt(d_bean) == 0){
				
					if(!ins_db.insertInsChangeDoc(d_bean)) flag += 1;
				
					//ins_change_doc_list
					vt = ins_db.getInsChangeDocList(ch_cd[i]);
					
					
					 for(int j=0; j < vt.size(); j++){
						temp_bean =(InsurChangeBean) vt.elementAt(j);
					 	bean.setIns_doc_no(reg_code);
						bean.setCh_tm(temp_bean.getCh_tm());
						bean.setCh_item(temp_bean.getCh_item());
						bean.setCh_before(temp_bean.getCh_after()); // 변경전을 변경후로
						bean.setCh_after(temp_bean.getCh_before()); // 변경후랄 변경전으로
						bean.setCh_amt(temp_bean.getCh_amt()); 
						bean.setCh_etc(ch_etc);
						if(!ins_db.insertInsChangeDocList(bean)) flag += 1; 
						
					}
					 
					//doc_settle
					UsersBean sender_bean 	= umd.getUsersBean(user_id);
					
					sub 	= "보험계약사항 변경요청문서 품의";
					cont 	= "["+firm_nm[i]+"] 보험변경문서를 등록하였으니 결재바랍니다.";
					
					user_id2 = nm_db.getWorkAuthUser("본사영업부팀장"); //20140415 영업팀장 결재 빠짐
					user_id3 = nm_db.getWorkAuthUser("부산보험담당");
					user_id4 = nm_db.getWorkAuthUser("세금계산서담당자"); //20151112 스케줄담당자 추가
					
					
					cs_bean2 = csd.getCarScheTodayBean(user_id2);
					cs_bean3 = csd.getCarScheTodayBean(user_id3);
					cs_bean4 = csd.getCarScheTodayBean(user_id4);
					
					
					if(!cs_bean2.getWork_id().equals("")) user_id2 = cs_bean2.getWork_id();
					if(!cs_bean3.getWork_id().equals("")) user_id3 = cs_bean3.getWork_id();
					if(!cs_bean4.getWork_id().equals("")) user_id4 = cs_bean4.getWork_id();
					
					//대전,부산보험담당자 모두 휴가일때
					cs_bean3 = csd.getCarScheTodayBean(user_id3);
					if(!cs_bean3.getWork_id().equals("")) user_id3 = cs_bean3.getWork_id();
					
					
					doc =  d_db.getDocSettle(doc_no[i]);
					
					
					doc.setDoc_st	("47");
					doc.setDoc_id	(reg_code);
					doc.setSub	(sub);
					doc.setCont	(cont);
					doc.setEtc	(ch_etc);
					doc.setUser_nm1	("기안자");
					doc.setUser_nm2	("영업팀장");
					//doc.setUser_nm3("영업팀장");
					doc.setUser_nm3	("보험담당자");
					doc.setUser_nm4	("스케줄담당자");
					doc.setUser_nm5	("");
					doc.setUser_id1	(user_id);
					doc.setUser_id2	(user_id2);
					doc.setUser_id3	(user_id3);
					doc.setUser_id4	(user_id4);
					doc.setDoc_bit	("0");
					doc.setDoc_step	("0");//기안
					
					if(ch_st.equals("2")){
						doc.setDoc_step	("3");//견적
					}
					
					//=====[doc_settle] insert=====
					if(!d_db.insertDocSettle2(doc)) flag += 1;
					
					// ACAR_ATTACH_FILE
					content_code = "LC_SCAN";
					content_seq  = d_bean.getRent_mng_id()+""+d_bean.getRent_l_cd();
					//System.out.println(content_seq);
					attachList = d_db.getAcarAttachFileList(content_code, content_seq);		
					for(AttachedFile attach : attachList  ){
						//System.out.println("1: "+d_bean.getReg_dt() + "<" + attach.getRegDate().substring(0, 10).replaceAll("-",""));
						if(AddUtil.parseInt(d_bean.getReg_dt()) <= AddUtil.parseInt(attach.getRegDate().substring(0, 10).replaceAll("-",""))){
								//System.out.println("2: "+doc.getVar01() + ">" + attach.getRegDate().substring(0, 10).replaceAll("-",""));
							if(!doc.getVar01().equals("") && 
								AddUtil.parseInt(doc.getVar01()) >= AddUtil.parseInt(attach.getRegDate().substring(0, 10).replaceAll("-",""))){
								//System.out.println("3: "+attach.getFileName());
								if(!ins_db.insertAttachedFile(attach))	flag += 1;
								
							}
						}
					}
					comple += d_bean.getRent_l_cd() + " ";
					
				}else{
					duple += d_bean.getRent_l_cd() + " ";
					dup_count++;
				}
			}
		}
	}catch(Exception e){
		System.out.println(e);
	}

%>

<html>
<head>
<title></title>
</head>
<body >
<script language='javascript'>
var comple = '<%=comple%>' ;
var duple = '<%=duple%>' ;
<%	if(flag > 0){%>
		alert("등록 중 오류가 발생되었습니다.");
<%	}else{%>	
<%		if(dup_count>0 && count > dup_count){	%>
			alert(comple+ "계약이 복귀되었습니다 \n중복건 : "+duple);
<%		}else if(dup_count>0 && count==dup_count ){	%>
			alert(duple+ "\n이미 복귀된 건 입니다");
<%		}else{ 				%>
			alert("복구가 완료 되었습니다");		
<%		} 					%>
<%	}%>
opener.location.reload();
self.close();

</script>
</body>
</html>