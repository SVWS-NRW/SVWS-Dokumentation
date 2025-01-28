import { defineLoader } from 'vitepress'

export interface Data {
	buildDate: number;
}

declare const data: Data
export { data }

export default defineLoader({
	async load(): Promise<Data> {
		return { buildDate: Date.now() };
	},
})